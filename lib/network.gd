extends Node


var ip = IP.get_local_addresses()[1]
var port = "6007"
var players = {}
var self_data = {
	name = '',
	position = {
		x = 100,
		y = 100
	},
	ip = IP.get_local_addresses()[1],
	ping = 'fs'
}


func _ready():
	# warning-ignore:return_value_discarded
	get_tree().connect("connection_failed", self, "_on_connection_failed")	
	# warning-ignore:return_value_discarded
	get_tree().connect('server_disconnected', self, '_on_server_disconnected')
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_on_player_connected")
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "_on_player_disconnected")


func start_server(port, max_players):
	self_data.name = '1'
	GameState.players[1] = self_data
	var peer = NetworkedMultiplayerENet.new()
	var error = peer.create_server(port, max_players)
	print("Starting server... Port: ", port, ". Errors: ", error)
	get_tree().set_network_peer(peer)
	return({
		"name": get_tree().get_network_unique_id(),
		"ip": ip,
		"ping": "-"
	})


func connect_to_server(ip, port, player_name):
	# warning-ignore:return_value_discarded
	get_tree().connect("connected_to_server", self, "_on_connected_to_server")
	var peer = NetworkedMultiplayerENet.new()
	var error = peer.create_client(str(ip), port)
	print("Connecting to the server... IP: ", ip, ", port: ", port, ". Errors: ", error)
	get_tree().set_network_peer(peer)


func _on_server_disconnected():
	print("Server ", ip, " disconnected...")
	#get_tree().get_rpc_sender_id()
	#peer.close_connection()


func _on_player_connected(id):
	if get_tree().is_network_server():
		print("Player: ", id, " connected...")
	else:
		pass


func _on_player_disconnected(id):
	print("Player ", id, " disconnected...")
	GameState.players.erase(id)


func _on_connected_to_server():
	self_data.name = get_tree().get_network_unique_id()
	rpc('_initiate_player_info', get_tree().get_network_unique_id(), self_data)


func _on_connection_failed():
	pass


remote func _set_player_boundaries(peer_id, boundaries):
	if get_tree().is_network_server():
		GameState.boundaries = boundaries
		GameState.boundaries.set = true
	else:
		rpc_id(1, '_set_player_boundaries', peer_id, boundaries)


func set_player_info(peer_id, position):
	rpc_unreliable_id(1, '_set_player_info', peer_id, position)


remote func _set_player_info(peer_id, position):
	if get_tree().is_network_server():
		if GameState.boundaries.set:
			if position.y < GameState.boundaries.y_up:
				position.y = GameState.boundaries.y_up
			elif position.y > GameState.boundaries.y_down:
				position.y = GameState.boundaries.y_down
		GameState.players[peer_id].position = position


func get_players_info(peer_id, info):
	rpc_unreliable_id(1, '_get_players_info', peer_id, null)


remote func _get_players_info(peer_id, info):
	if get_tree().is_network_server():
		rpc_unreliable_id(peer_id, '_get_players_info', peer_id, GameState.players)
	else:
		GameState.players = info


remote func _initiate_player_info(id, info):
	GameState.players[id] = info
	var no_server_players = []
	for key in GameState.players.keys():
		if key != 1:
			no_server_players.append(key)

	if get_tree().is_network_server():
		for peer_id in no_server_players:
			rpc_id(id, '_initiate_player_info', peer_id, GameState.players[peer_id])
	else:
		var new_player = get_tree().get_root().get_node("Game").init_player(id)
		rpc_id(1, '_set_player_boundaries', id, new_player.boundaries)
