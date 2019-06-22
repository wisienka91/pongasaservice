extends KinematicBody2D

var speed = 222
var size = null
var boundaries = null
var peer_id = null
var is_left = true
var is_operating = false

func _ready():
	peer_id = get_tree().get_network_unique_id()
	size = {
		x = get_node("CollisionShape2D").get_shape().get_extents()[0],
		y = get_node("CollisionShape2D").get_shape().get_extents()[1]
	}
	position.x += get_transform().get_scale().x * size.x
	position.y += get_transform().get_scale().y * size.y
	boundaries = {
		y_up = 0,
		y_down = get_viewport().size.y,
		x_left = 0,
		x_right = get_viewport().size.x,
		player_x_size = position.x,
		player_y_size = position.y
	}
	is_left = false

func _physics_process(delta):
	if is_operating:
		var new_position = {
			x = position.x,
			y = position.y
		}
		if Input.is_action_pressed("ui_up"):
			new_position.y -= speed * delta
		elif Input.is_action_pressed("ui_down"):
			new_position.y += speed * delta
		Network.set_player_info(peer_id, new_position)
