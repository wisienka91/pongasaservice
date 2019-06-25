extends Node

var players = []
var peer_id = null
var player_id = null
var visible_players = []
const playerScene = preload("res://game/Player.tscn")

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
		init_player(player_id, false)

func _physics_process(delta):
	if peer_id == null:
		peer_id = get_tree().get_network_unique_id()
	else:
		var ball = get_node("Ball")
		Network.get_ball_info(peer_id, null)
		ball.position = GameState.ball.ball_position

		if len(visible_players) == 0:
			var new_player = init_player(peer_id, true)
			Network.set_player_boundaries(peer_id, new_player.boundaries)
		elif len(GameState.players.keys()) > len(visible_players):
			var players_to_add = get_players_to_add()
			add_players(players_to_add)
		elif len(GameState.players.keys()) < len(players):
			pass
		else:
			pass

		players = $Players.get_children()
		print("test")
		for player in players:
			Network.get_players_info(peer_id, null)
			print(player.name, " ", player.peer_id, " ", GameState.players)
			#print(GameState.players.get(player.peer_id))
			var peer_data = GameState.players.get(player.peer_id)
			if peer_data != null:
				print("test3")
				#print(player.peer_id, " : ", player.position)
				#player.position.y = peer_data.position.y
			else:
				print("test4")

func init_player(player_id, is_operating):
	var new_player = playerScene.instance()
	new_player.is_operating = is_operating
	if is_operating:
		new_player.position = Vector2(
			GameState.boundaries.player_x_size,
			GameState.boundaries.player_y_size
		)
		print("Is operating")
	else:
		new_player.player_id = player_id
		new_player.position = Vector2(
		1000 + GameState.boundaries.player_x_size,
		GameState.boundaries.player_y_size
		)
		print("Not operating")
	$Players.add_child(new_player)
	visible_players.append(player_id)
	print("Adding new player")
	return new_player
