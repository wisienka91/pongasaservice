extends Node


var players = {}
var server = {}
var ball = {
	ball_position = Vector2(512, 384),
	ball_speed = Vector2(50, 50),
	ball_radius = 12,
}
var boundaries = {
	y_up = null,
	y_down = null,
	set = false,
	x_up = null,
	x_down = null,
	player_x_size = null,
	player_y_size = null
}


func _ready():
	set_process(true)


func _process(delta):
	pass
