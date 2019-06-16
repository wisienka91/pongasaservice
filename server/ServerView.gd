extends Node2D

const PeerItem = preload("res://server/PeerItem.tscn")

var listIndex = 0
var playersVisible = []


func addItem(node_data):
	var item = PeerItem.instance()
	item.get_node("IdLabel").text = str(node_data.name)
	item.get_node("IPLabel").text = node_data.ip
	item.get_node("PingLabel").text = node_data.ping
	$Panel/ScrollContainer/PeersList.add_child(item)
	if str(node_data.name) != "PeerId":
		playersVisible.append(node_data.name)

func _ready():
	var port = SceneSwitcher.get_param("port")
	var max_players = SceneSwitcher.get_param("max_players")
	var max_points = SceneSwitcher.get_param("max_points")

	var node_data = Network.start_server(port, max_players)
	var key_data = {
		"name": "PeerId",
		"ip": "IP address",
		"ping": "PING"
	}
	addItem(key_data)
	addItem(node_data)

func _process(delta):
	for key in GameState.players.keys():
		if not playersVisible.has(key):
			playersVisible.append(key)
			addItem(GameState.players[key])
	#TO-DO: remove child when disconnected
