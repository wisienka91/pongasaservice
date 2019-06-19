extends Node

func _ready():
	var new_player = preload("res://game/Player.tscn").instance()

#remote func pre_configure_game():
#    get_tree().set_pause(true)
