extends Node

func _update_ball(delta):
	GameState.ball.ball_position += GameState.ball.ball_speed * delta
	_wall_collision()

func _wall_collision():
	if GameState.ball.ball_position.y > GameState.ball_boundaries.y_down - GameState.ball_boundaries.radius:
		GameState.ball.ball_speed.y *= -1
	elif GameState.ball.ball_position.y < GameState.ball_boundaries.y_up + GameState.ball_boundaries.radius:
		GameState.ball.ball_speed.y *= -1
	if GameState.ball.ball_position.x > GameState.ball_boundaries.x_right - GameState.ball_boundaries.radius:
		print("Left side scored")
	elif GameState.ball.ball_position.x < GameState.ball_boundaries.x_left + GameState.ball_boundaries.radius:
		print("Right side scored")

func _player_collision():
	pass

func _physics_process(delta):
	if GameState.started:
		if get_tree().is_network_server():
			_update_ball(delta)