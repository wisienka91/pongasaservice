extends Node


var ip = "127.0.0.1"
var peer = null


func _ready():
	# warning-ignore:return_value_discarded
	get_tree().connect("connection_failed", self, "_on_connection_failed")	
	# warning-ignore:return_value_discarded
	get_tree().connect("connected_to_server", self, "_on_connected_to_server")	
	# warning-ignore:return_value_discarded
	get_tree().connect('server_disconnected', self, '_on_server_disconnected')
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_on_player_connected")
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "_on_player_disconnected")


func start_server(port, max_players):
	peer = NetworkedMultiplayerENet.new()
	var error = peer.create_server(port, max_players)
	print("Starting server... Port: ", port, ". Errors: ", error)
	get_tree().set_network_peer(peer)


func connect_to_server(ip, port):
	peer = NetworkedMultiplayerENet.new()
	var error = peer.create_client(ip, port)
	print("Connecting to the server... IP: ", ip, ", port: ", port, ". Errors: ", error)
	get_tree().set_network_peer(peer)


func _on_server_disconnected():
	print('Server ", ip, " disconnected...')
	peer.close_connection()


func _on_player_connected(id):
	#rpc_id(id, 'instance_remote_player', get_tree().get_network_unique_id(), get_tree().is_network_server())
	pass


func _on_player_disconnected(id):
	pass


func _on_connected_to_server():
	pass


func _on_connection_failed():
	pass
