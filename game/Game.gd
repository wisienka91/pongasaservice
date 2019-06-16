extends Node

func _ready():
	var new_player = preload("res://game/Player.tscn").instance()
	new_player.name = "readyplayerone"

#remote func pre_configure_game():
#    get_tree().set_pause(true)
