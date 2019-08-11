extends Node

onready var playerScene = preload("res://client/Player.tscn")
var players = []
var peer_id = null
var visible_players = []
var controlling = null

func _ready():
	peer_id = get_tree().get_network_unique_id()
	controlling = init_player(peer_id)

func get_players_to_add():
	var players_to_add = []
	for player_id in GameState.players.keys():
		if not visible_players.has(player_id):
			players_to_add.append(player_id)
	return players_to_add

func add_players(players_to_add):
	for player_id in players_to_add:
		init_player(player_id)

func _physics_process(delta):
	Network.get_players_info(peer_id, null)
	if !GameState.player_boundaries_set:
		_set_player_boundaries()
	if !GameState.ball_boundaries_set:
		_set_ball_boundaries()

	_display_players()
	_update_players()
	_update_ball()

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
	elif len(GameState.players.keys()) < len(players):
		# TO-DO:
		# - remove disconnected players
		pass
	else:
		pass

func _update_players():
	if controlling.position != controlling.new_position:
		Network.set_player_info(peer_id, controlling.new_position)
	for player in GameState.players:
		$Players.get_node(str(player)).position.y = GameState.players[player].position.y
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

	$Players.add_child(new_player)
	visible_players.append(player_id)
	return new_player
