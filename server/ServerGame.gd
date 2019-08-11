extends Node

func _update_ball(delta):
	GameState.ball.ball_position += GameState.ball.ball_speed * delta
	if GameState.player_boundaries_set and GameState.started:
		_wall_collision()
		_player_collision()

func _wall_collision():
	if GameState.ball.ball_position.y > GameState.ball_boundaries.y_down - GameState.ball_boundaries.radius:
		GameState.ball.ball_speed.y *= -1
	elif GameState.ball.ball_position.y < GameState.ball_boundaries.y_up + GameState.ball_boundaries.radius:
		GameState.ball.ball_speed.y *= -1
	if GameState.ball.ball_position.x > GameState.ball_boundaries.x_right - GameState.ball_boundaries.radius:
		print("Left side scored")
	elif GameState.ball.ball_position.x < GameState.ball_boundaries.x_left + GameState.ball_boundaries.radius:
		print("Right side scored")

func _check_player(player, side):
	var up_player = GameState.ball.ball_position.y > GameState.players[player].position.y - GameState.player_boundaries.size.y
	var down_player = GameState.ball.ball_position.y < GameState.players[player].position.y + GameState.player_boundaries.size.y
	var contact_player = false
	if side == "left":
		contact_player = GameState.ball.ball_position.x < GameState.player_boundaries.left_player + GameState.player_boundaries.size.x + GameState.ball_boundaries.radius
	elif side == "right":
		contact_player = GameState.ball.ball_position.x > GameState.player_boundaries.right_player - 2 * GameState.player_boundaries.size.x - GameState.ball_boundaries.radius
	else:
		pass

	if up_player and down_player and contact_player:
		GameState.ball.ball_speed.x *= -1

func _check_left():
	for player in GameState.players:
		# TO-DO:
		# check just left players
		_check_player(player, "left")

func _check_right():
	for player in GameState.players:
		# TO-DO:
		# check just right players
		_check_player(player, "right")

func _player_collision():
	if GameState.ball.ball_position.x < GameState.ball_boundaries.x_left + 15 * GameState.ball_boundaries.radius:
		_check_left()
	elif GameState.ball.ball_position.x > GameState.ball_boundaries.x_right - 15 * GameState.ball_boundaries.radius:
		_check_right()

func _physics_process(delta):
	if GameState.started:
		if get_tree().is_network_server():
			_update_ball(delta)