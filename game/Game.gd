extends Node

onready var playerScene = preload("res://game/Player.tscn")
var players = []
var peer_id = null
var visible_players = []
onready var debug = $GUI/debug

var controlling = null

func _ready():
	peer_id = get_tree().get_network_unique_id()
	var new_player = init_player(peer_id)
	controlling = new_player

func get_players_to_add():
	var players_to_add = []
	for player_id in GameState.players.keys():
		if not visible_players.has(player_id):
			players_to_add.append(player_id)
	print("Players to add: ", players_to_add )
	return players_to_add

func add_players(players_to_add):
	for player_id in players_to_add:
		init_player(player_id)

func _physics_process(delta):
	Network.get_players_info(peer_id, null)

	if len(GameState.players.keys()) > len(visible_players):
		var players_to_add = get_players_to_add()
		add_players(players_to_add)
	elif len(GameState.players.keys()) < len(players):
		pass
	else:
		pass

	Network.set_player_info(peer_id, controlling.new_position)

	players = $Players.get_children()
	for player in GameState.players:
		$Players.get_node(str(player)).position.y = GameState.players[player].position.y


func init_player(player_id):
	debug.text += 'creating new player ' + str(player_id) + '\n'
	var new_player = playerScene.instance()
	new_player.name = str(player_id)
	if player_id == peer_id:
		new_player.is_operating = true

	$Players.add_child(new_player)
	visible_players.append(player_id)
	return new_player
