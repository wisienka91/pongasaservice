extends KinematicBody2D

var speed = 222
var size = null
var boundaries = null
var is_left = true
var is_operating = false
var new_position = Vector2.ZERO

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
	is_left = false

func _physics_process(delta):
	if is_operating:
		if Input.is_action_pressed("ui_up"):
			new_position.y -= speed * delta
		elif Input.is_action_pressed("ui_down"):
			new_position.y += speed * delta
