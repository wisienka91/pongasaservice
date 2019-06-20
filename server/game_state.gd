extends Node


var ball_position = Vector2(512, 384)
var players = {}
var boundaries = {
	y_up = null,
	y_down = null,
	set = false
}


func _ready():
	set_process(true)


func _process(delta):
	pass
