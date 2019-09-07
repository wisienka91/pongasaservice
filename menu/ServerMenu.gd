extends Node2D

var port = 6007
var max_players = 2
var max_points = 3


func _ready():
	# warning-ignore:return_value_discarded
	get_node("ActionButtonsContainer/StartMarginContainer/StartButton").connect(
		"pressed", self, "_on_start_button_pressed")

	# warning-ignore:return_value_discarded
	get_node("ActionButtonsContainer/BackMarginContainer/BackButton").connect(
		"pressed", self, "_on_back_button_pressed")

	# warning-ignore:return_value_discarded
	get_node("ActionButtonsContainer/QuitMarginContainer/QuitButton").connect(
		"pressed", self, "_on_quit_button_pressed")

	# warning-ignore:return_value_discarded
	get_node("ServerInputContainer/PortMarginContainer/PortInput").connect(
	"text_changed", self, "_on_port_input_changed")

	# warning-ignore:return_value_discarded
	get_node("ServerInputContainer/PlayersMarginContainer/PlayersInput").connect(
	"text_changed", self, "_on_max_players_input_changed")

	# warning-ignore:return_value_discarded
	get_node("ServerInputContainer/PointsMarginContainer/PointsInput").connect(
	"text_changed", self, "_on_max_points_input_changed")

func _on_start_button_pressed():
	SceneSwitcher.switch_scene("res://server/ServerView.tscn", {
		"port": port, "max_players": max_players, "max_points": max_points})


func _on_back_button_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://menu/MainMenu.tscn")

func _on_port_input_changed(new_port):
	if int(new_port) > 0:
		port = int(new_port)
	else:
		port = null

func _on_max_players_input_changed(new_max_players):
	if int(new_max_players) > 0:
		max_players = int(new_max_players)
	else:
		max_players = 0

func _on_max_points_input_changed(new_max_points):
	if int(new_max_points) > 0:
		max_points = int(new_max_points)
	else:
		max_points = 0

func _on_quit_button_pressed():
	get_tree().quit()
