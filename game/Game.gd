extends Node

var players = []
var peer_id = null

func _ready():
	peer_id = get_tree().get_network_unique_id()

func _physics_process(delta):
	players = get_tree().get_root().get_node("Game").get_node("Players").get_children()
	for player in players:
		Network.get_players_info(peer_id, null)
		player.position.y = GameState.players[peer_id].position.y

func init_player(id):
	var new_player = load("res://game/Player.tscn").instance()
	new_player.name = str(id)
	get_tree().get_root().get_node("Game").get_node("Players").add_child(new_player)
	return new_player
