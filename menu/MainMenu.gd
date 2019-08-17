extends Node2D


func _ready():
	# warning-ignore:return_value_discarded
	get_node("NodeTypeContainer/ServerMarginContainer/ServerButton").connect(
		"pressed", self, "_on_server_button_pressed")

	# warning-ignore:return_value_discarded
	get_node("NodeTypeContainer/ClientMarginContainer/ClientButton").connect(
		"pressed", self, "_on_client_button_pressed")

	# warning-ignore:return_value_discarded
	get_node("QuitButtonsContainer/QuitMarginContainer/QuitButton").connect(
	    "pressed", self, "_on_quit_button_pressed")

func _on_server_button_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://menu/ServerMenu.tscn")

func _on_client_button_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://menu/ClientMenu.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
