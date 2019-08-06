extends Node

var started = false

var ball = {
	ball_position = Vector2(512, 384),
	ball_speed = Vector2(-25, 20),
	ball_direction = Vector2(0, 0)
}

var players = {}
var server = {}
var player_boundaries = {
	y_up = null,
	y_down = null,
	size = null,
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
