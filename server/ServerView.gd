extends Node2D

func _ready():
	var port = SceneSwitcher.get_param("port")
	var max_players = SceneSwitcher.get_param("max_players")
	var max_points = SceneSwitcher.get_param("max_points")

	Network.start_server(port, max_players)
