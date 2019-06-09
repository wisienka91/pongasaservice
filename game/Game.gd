extends Node


func _ready():
	pass


remote func pre_configure_game():
    get_tree().set_pause(true)
