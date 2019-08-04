extends Node

var started = false

var ball = {
	ball_position = Vector2(512, 384),
	ball_speed = Vector2(20, -20),
	ball_direction = Vector2(0, 0)
}

var players = {}
var server = {}
var player_boundaries = {
	y_up = null,
	y_down = null,
	left_player = null,
	right_player = null
}
var player_boundaries_set = false

var ball_boundaries = {
	radius = null,
	x_left = null,
	x_right = null,
	y_up = null,
	y_down = null
}

var ball_boundaries_set = false

func _update_ball(delta):
	ball.ball_position += ball.ball_speed * delta
	_wall_collision()

func _wall_collision():
	if ball.ball_position.y > ball_boundaries.y_down - ball_boundaries.radius:
		ball.ball_speed.y *= -1
	elif ball.ball_position.y < ball_boundaries.y_up + ball_boundaries.radius:
		ball.ball_speed.y *= -1
	if ball.ball_position.x > ball_boundaries.x_right - ball_boundaries.radius:
		print("Left side scored")
	elif ball.ball_position.x < ball_boundaries.x_left + ball_boundaries.radius:
		print("Right side scored")

func _player_collision():
	pass

func _physics_process(delta):
	if started:
		if get_tree().is_network_server():
			_update_ball(delta)
