extends Node

onready var playerScene = preload("res://client/Player.tscn")
var players = []
var peer_id = null
var visible_players = []
var controlling = null

func _ready():
	peer_id = get_tree().get_network_unique_id()
	Network.get_players_info(peer_id, null)
	Network.get_side_info(peer_id, null)

func get_players_to_add():
	var players_to_add = []
	for player_id in GameState.players.keys():
		if not visible_players.has(player_id):
			players_to_add.append(player_id)
	return players_to_add

func get_players_to_remove():
	var players_to_remove = []
	for player_id in visible_players:
		if not GameState.players.keys().has(player_id):
			players_to_remove.append(player_id)
	return players_to_remove

func remove_players(players_to_remove):
	for player_id in players_to_remove:
		remove_player(player_id)

func remove_player(player_id):
	var player_objects = $Players.get_children()
	for player_object in player_objects:
		if player_object.name == str(player_id):
			$Players.remove_child(player_object)
			player_object.queue_free()
			visible_players.erase(player_id)

func add_players(players_to_add):
	for player_id in players_to_add:
		init_player(player_id)

func _update_score():
	Network.get_score_info(peer_id, null)
	$LeftScoreContainer/ScoreLeft.text = str(GameState.score.left)
	$RightScoreContainer/ScoreRight.text = str(GameState.score.right)

func _physics_process(delta):
	Network.get_players_info(peer_id, null)
	if !GameState.player_boundaries_set and controlling:
		_set_player_boundaries()
	if !GameState.ball_boundaries_set:
		_set_ball_boundaries()

	_display_players()
	_update_players()
	_update_ball()
	_update_score()

func _set_player_boundaries():
	Network.set_player_boundaries(peer_id, controlling.player_boundaries)
	Network.get_player_boundaries_info(peer_id, null)

func _set_ball_boundaries():
	var ball = get_node("Ball")
	var ball_scale = ball.get_transform().get_scale().x
	var ball_boundaries = {
		x_left = 0,
		x_right = get_viewport().size.x,
		y_up = 0,
		y_down = get_viewport().size.y,
		radius = ball_scale * ball.get_node("CollisionShape").get_shape().radius
	}

	Network.set_ball_boundaries(peer_id, ball_boundaries)
	Network.get_ball_boundaries_info(peer_id, null)

func _display_players():
	if len(GameState.players.keys()) > len(visible_players):
		var players_to_add = get_players_to_add()
		add_players(players_to_add)
	elif len(GameState.players.keys()) < len(visible_players):
		var players_to_remove = get_players_to_remove()
		remove_players(players_to_remove)
	else:
		pass

func _update_players():
	Network.get_side_info(peer_id, null)
	if controlling:
		if controlling.position != controlling.new_position:
			Network.set_player_info(peer_id, controlling.new_position)

	for player in GameState.players:
		$Players.get_node(str(player)).position.y = GameState.players[player].position.y
	if controlling:
		controlling.new_position = controlling.position

func _update_ball():
	Network.get_ball_info(peer_id, null)
	$Ball.position = GameState.ball.ball_position

func init_player(player_id):
	var new_player = playerScene.instance()
	new_player.name = str(player_id)
	if player_id == peer_id:
		new_player.is_operating = true
		new_player.z_index = 10
		controlling = new_player
	new_player.is_left = GameState.players[player_id].is_left

	$Players.add_child(new_player)
	visible_players.append(player_id)
	return new_player
