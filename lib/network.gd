extends Node


var ip = IP.get_local_addresses()[1]
var port = "6007"
var players = {}
var self_data = {}
var ping_timer = Timer.new()

signal ping_updated

func _ready():
	# warning-ignore:return_value_discarded
	get_tree().connect("connection_failed", self, "_on_connection_failed")	
	# warning-ignore:return_value_discarded
	get_tree().connect('server_disconnected', self, '_on_server_disconnected')
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_on_player_connected")
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "_on_player_disconnected")

	self_data = {
		name = '',
		position = {
			x = 100,
			y = get_viewport().size.y / 2
		},
		ip = IP.get_local_addresses()[1],
		ping = 0,
		ping_start = 0
	}

func _ping_timer_setup():
	ping_timer.connect('timeout', self, 'ping_send')
	ping_timer.set_wait_time(1)
	ping_timer.set_one_shot(false)
	add_child(ping_timer)
	ping_timer.start()

func start_server(port, max_players):
	self_data.name = '1'
	GameState.server[1] = self_data
	GameState.is_next_player_left = true
	var peer = NetworkedMultiplayerENet.new()
	var error = peer.create_server(port, max_players)
	print(OS.get_time(), " Starting server... Port: ", port, ". Errors: ", error)
	get_tree().set_network_peer(peer)
	_ping_timer_setup()

	return({
		"name": str(get_tree().get_network_unique_id()),
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
	print(OS.get_time(), " Server ", ip, " disconnected...")
	#get_tree().get_rpc_sender_id()
	#peer.close_connection()

func _on_player_connected(id):
	if get_tree().is_network_server():
		print(OS.get_time(), " PCONN - Player - ", id, " - connected...")

func _on_player_disconnected(id):
	print(OS.get_time(), " PDCONN - Player - ", id, " - disconnected...")
	GameState.is_next_player_left = GameState.players[id].is_left
	GameState.players.erase(id)

func _on_connected_to_server():
	self_data.name = get_tree().get_network_unique_id()
	rpc_id(1, '_initiate_player_info', get_tree().get_network_unique_id(), self_data)

func _on_connection_failed():
	pass

func set_player_boundaries(peer_id, player_boundaries):
	rpc_id(1, '_set_player_boundaries', peer_id, player_boundaries)

remote func _set_player_boundaries(peer_id, player_boundaries):
	if get_tree().is_network_server():
		GameState.player_boundaries = player_boundaries
		GameState.player_boundaries_set = true

func set_player_info(peer_id, position):
	rpc_unreliable_id(1, '_set_player_info', peer_id, position)

remote func _set_player_info(peer_id, position):
	if peer_id in GameState.players.keys():
		if get_tree().is_network_server():
			if GameState.player_boundaries_set:
				if position.y < GameState.player_boundaries.y_up:
					position.y = GameState.player_boundaries.y_up
				elif position.y > GameState.player_boundaries.y_down:
					position.y = GameState.player_boundaries.y_down
				GameState.players[peer_id].position = position

func get_player_boundaries_info(peer_id, info):
	rpc_id(1, '_get_player_boundaries_info', peer_id, null)

remote func _get_player_boundaries_info(peer_id, info):
	if get_tree().is_network_server():
		rpc_id(peer_id, '_get_player_boundaries_info', peer_id, GameState.player_boundaries_set)
	else:
		GameState.player_boundaries_set = info

func get_ball_info(peer_id, info):
	rpc_unreliable_id(1, '_get_ball_info', peer_id, null)

remote func _get_ball_info(peer_id, info):
	if get_tree().is_network_server():
		rpc_unreliable_id(peer_id, '_get_ball_info', peer_id, GameState.ball)
	else:
		GameState.ball = info

func get_score_info(peer_id, info):
	rpc_unreliable_id(1, '_get_score_info', peer_id, null)

remote func _get_score_info(peer_id, info):
	if get_tree().is_network_server():
		rpc_unreliable_id(peer_id, '_get_score_info', peer_id, GameState.score)
	else:
		GameState.score = info

func set_ball_boundaries(peer_id, ball_boundaries):
	rpc_id(1, '_set_ball_boundaries', peer_id, ball_boundaries)

remote func _set_ball_boundaries(peer_id, ball_boundaries):
	if get_tree().is_network_server():
		GameState.ball_boundaries = ball_boundaries
		GameState.ball_boundaries_set = true

func get_ball_boundaries_info(peer_id, info):
	rpc_id(1, '_get_player_boundaries_info', peer_id, null)

remote func _get_ball_boundaries_info(peer_id, info):
	if get_tree().is_network_server():
		rpc_id(peer_id, '_get_player_boundaries_info', peer_id, GameState.ball_boundaries_set)
	else:
		GameState.ball_boundaries_set = info

func get_players_info(peer_id, info):
	rpc_unreliable_id(1, '_get_players_info', peer_id, null)

remote func _get_players_info(peer_id, info):
	if get_tree().is_network_server():
		rpc_unreliable_id(peer_id, '_get_players_info', peer_id, GameState.players)
	else:
		GameState.players = info

remote func _initiate_player_info(id, info):
	info.is_left = GameState.is_next_player_left
	GameState.players[id] = info

	if get_tree().is_network_server():
		GameState.is_next_player_left = not GameState.is_next_player_left

func get_side_info(peer_id, info):
	rpc_id(1, '_get_side_info', peer_id, null)

remote func _get_side_info(peer_id, info):
	if get_tree().is_network_server():
		rpc_id(peer_id, '_get_side_info', peer_id, GameState.players[peer_id].is_left)
	else:
		GameState.players[peer_id].is_left = info

func ping_send():
	if get_tree().is_network_server():
		for player_id in GameState.players.keys():
			GameState.players[player_id].start_ping = OS.get_ticks_msec()
			rpc_unreliable_id(player_id, 'ping_receive', player_id)

remote func ping_receive(player_id):
	rpc_unreliable_id(1, 'ping_response', player_id)

remote func ping_response(player_id):
	GameState.players[player_id].ping = OS.get_ticks_msec() - GameState.players[player_id].start_ping
	emit_signal("ping_updated")
