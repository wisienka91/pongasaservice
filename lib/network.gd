extends Node


var ip = "127.0.0.1"
var port = "6007"
var players = {}
var self_data = {
	name = '',
	position = Vector2(100, 100)
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
	self_data.name = 'server0'
	players[1] = self_data
	var peer = NetworkedMultiplayerENet.new()
	var error = peer.create_server(port, max_players)
	print("Starting server... Port: ", port, ". Errors: ", error)
	get_tree().set_network_peer(peer)


func connect_to_server(ip, port, player_name):
	# warning-ignore:return_value_discarded
	get_tree().connect("connected_to_server", self, "_on_connected_to_server")
	var peer = NetworkedMultiplayerENet.new()
	var error = peer.create_client(str(ip), port)
	print("Connecting to the server... IP: ", ip, ", port: ", port, ". Errors: ", error)
	get_tree().set_network_peer(peer)


func _on_server_disconnected():
	#print('Server ", ip, " disconnected...')
	#peer.close_connection()
	pass


func _on_player_connected(id):
	print("Player: ", id, " connected...")
	#rpc_id(id, 'instance_remote_player', get_tree().get_network_unique_id(), get_tree().is_network_server())
	pass


func _on_player_disconnected(id):
	print("Player ", id, " disconnected...")
	players.erase(id)


func _on_connected_to_server():
	#players[get_tree().get_network_unique_id()] = self_data
	#rpc('_send_player_info', get_tree().get_network_unique_id(), self_data)
	pass


func _on_connection_failed():
	pass


remote func _send_player_info(id, info):
	if get_tree().is_network_server():
		for peer_id in players:
			rpc_id(id, '_send_player_info', peer_id, players[peer_id])
	players[id] = info
	var new_player = load("res://game/Player.tscn").instance()
	new_player.name = str(id)
	new_player.set_network_master(id)
	get_tree().get_root().add_child(new_player)
	new_player.init(info.name, info.position, true)

func update_position(id, position):
	players[id].position = position
