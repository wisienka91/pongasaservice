extends Node2D

const PeerItem = preload("res://server/PeerItem.tscn")

var listIndex = 0
var playersVisible = []
var server_data = null


func addItem(node, child_data):
	var item = PeerItem.instance()
	item.get_node("IdLabel").text = str(child_data.name)
	item.get_node("IPLabel").text = child_data.ip
	item.get_node("PingLabel").text = child_data.ping
	node.add_child(item)
	if str(child_data.name) != "PeerId":
		playersVisible.append(child_data.name)

func _ready():
	var port = SceneSwitcher.get_param("port")
	var max_players = SceneSwitcher.get_param("max_players")
	var max_points = SceneSwitcher.get_param("max_points")

	server_data = Network.start_server(port, max_players + 1)
	var key_data = {
		"name": "PeerId",
		"ip": "IP address",
		"ping": "PING"
	}
	addItem($Panel/PeersKey, key_data)
	addItem($Panel/ScrollContainer/PeersList, GameState.server[1])

func _add_players():
	for key in GameState.players.keys():
		if not playersVisible.has(key):
			addItem($Panel/ScrollContainer/PeersList, GameState.players[key])

func _remove_players():
	var playersToRemove = []
	for key in playersVisible:
		if (not GameState.players.keys().has(key) and str(key) != "1"):
			playersToRemove.append(key)
	if len(playersToRemove) > 0:
		var peersPlayers = {}
		var peers = $Panel/ScrollContainer/PeersList.get_children()
		for peer in peers:
			peersPlayers[peer.get_node("IdLabel").text] = peer

		for key in playersToRemove:
			playersVisible.erase(key)
			var peer = peersPlayers.get(str(key))
			$Panel/ScrollContainer/PeersList.remove_child(peer)
			peer.queue_free()

#func _update_ping():
	# TO-DO:
	# - update ping
#	pass

func _process(delta):
	_add_players()
	_remove_players()
	#_update_ping()
