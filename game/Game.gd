extends Node

onready var playerScene = preload("res://game/Player.tscn")
var players = []
var peer_id = null
var visible_players = []

func _ready():
	pass

func get_players_to_add():
	var players_to_add = []
	for player_id in GameState.players.keys():
		if not visible_players.has(player_id):
			players_to_add.append(player_id)
	print("Players to add: ", players_to_add )
	return players_to_add

func add_players(players_to_add):
	for player_id in players_to_add:
		init_player(player_id)

func _physics_process(delta):
	if peer_id == null:
		peer_id = get_tree().get_network_unique_id()
	else:
		if len(visible_players) == 0:
			var new_player = init_player(peer_id)
			Network.set_player_boundaries(peer_id, new_player.boundaries)
		elif len(GameState.players.keys()) > len(visible_players):
			var players_to_add = get_players_to_add()
			add_players(players_to_add)
		elif len(GameState.players.keys()) < len(players):
			pass
		else:
			pass

	Network.get_players_info(peer_id, null)
	players = get_tree().get_root().get_node("Game").get_node("Players").get_children()
	for player in players:
		player.position.y = GameState.players[player.peer_id].position.y

func init_player(peer_id):
	var new_player = playerScene.instance()
	get_tree().get_root().get_node("Game").get_node("Players").add_child(new_player)
	visible_players.append(peer_id)
	return new_player
