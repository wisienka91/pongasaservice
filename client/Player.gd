extends KinematicBody2D

const OPERATING_COLOR = Color(0, 0.75, 1)
var speed = 333
var player_size = null
var player_boundaries = null
var is_left = true
var is_operating = false
var new_position = Vector2.ZERO
var operating_color_set = false

func _ready():
	player_size = {
		x = get_node("CollisionShape2D").get_shape().get_extents()[0],
		y = get_node("CollisionShape2D").get_shape().get_extents()[1]
	}
	position.x += get_transform().get_scale().x * player_size.x
	position.y += get_transform().get_scale().y * player_size.y
	player_boundaries = {
		y_up = position.y,
		y_down = get_viewport().size.y - 2 * player_size.y,
		size = Vector2(get_transform().get_scale().x * player_size.x, get_transform().get_scale().y * player_size.y),
		left_player = get_transform().get_scale().x * player_size.x,
		right_player = get_viewport().size.x
	}

	is_left = false

	if !is_left:
		position.x = player_boundaries.right_player - player_boundaries.size[0]
	new_position = position

func _physics_process(delta):
	if is_operating:
		if Input.is_action_pressed("ui_up"):
			new_position.y -= speed * delta
		elif Input.is_action_pressed("ui_down"):
			new_position.y += speed * delta

		if !operating_color_set:
			$Sprite.set_self_modulate(OPERATING_COLOR)
			operating_color_set = true
