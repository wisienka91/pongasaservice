extends Node2D

var ip = ""
var port = 6007

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
	get_node("ClientInputContainer/IPMarginContainer/IPInput").connect(
	"text_changed", self, "_on_ip_input_changed")

	# warning-ignore:return_value_discarded
	get_node("ClientInputContainer/PortMarginContainer/PortInput").connect(
	"value_changed", self, "_on_port_input_changed")


func _on_start_button_pressed():
	Network.connect_to_server(ip, port, "player3")
	get_tree().change_scene("res://game/Game.tscn")


func _on_back_button_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://menu/MainMenu.tscn")


func _on_ip_input_changed(new_ip):
	ip = new_ip


func _on_port_input_changed(new_port):
	if int(new_port) > 0:
		port = int(new_port)
	else:
		port = null


func _on_quit_button_pressed():
	get_tree().quit()
