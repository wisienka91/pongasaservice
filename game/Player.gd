extends KinematicBody2D

var speed = 3
var size = null
var boundaries = null

func _ready():
	size = {
		x = get_node("CollisionShape2D").get_shape().get_extents()[0],
		y = get_node("CollisionShape2D").get_shape().get_extents()[1]
	}
	position.x += get_transform().get_scale().x * size.x
	position.y += get_transform().get_scale().y * size.y
	boundaries = {
		y_up = position.y,
		y_down = get_viewport().size.y - 2 * size.y
	}

func _physics_process(delta):
	if Input.is_action_pressed("ui_up"):
		position.y -= speed
	elif Input.is_action_pressed("ui_down"):
		position.y += speed


	if position.y < boundaries.y_up:
		position.y = boundaries.y_up
	elif position.y > boundaries.y_down:
		position.y = boundaries.y_down