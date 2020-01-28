extends Node2D

enum {CENTER, UP, DOWN, LEFT, RIGHT}

var start_positions
var bomb_scene
var explosion_scene

var other_players = []

func _ready():
	start_positions = [$StartPositionPlayer1, $StartPositionPlayer2, $StartPositionPlayer3, $StartPositionPlayer4]
	bomb_scene = preload("res://Scenes/Bomb.tscn")
	explosion_scene = preload("res://Scenes/Explosion.tscn")

func new_game(map):
	# Networking
	var network = NetworkedMultiplayerENet.new()
	network.create_client("127.0.0.1", 4242)
	get_tree().set_network_peer(network)
	network.connect("connection_failed", self, "_on_connection_failed")
	network.connect("connection_succeeded", self, "_on_connection_succeeded")
	get_tree().multiplayer.connect("network_peer_packet", self, "_on_peer_packet_received")
	
	# Scene setup
	var scene
	if map == 1:
		scene = load("res://Scenes/Map1.tscn")
	elif map == 2:
		scene = load("res://Scenes/Map2.tscn")
	var scene_insance = scene.instance()
	scene_insance.set_name("Map")
	add_child(scene_insance)
	$HUD.show_message("Get Ready")

func _on_StartTimer_timeout():
	$Player.enable_controls()
	for player in other_players:
		get_node(player).enable_animations()
	$HUD.hide_message()

func _on_Player_bomb_placed(pos):
	var bomb = bomb_scene.instance()
	bomb.set_position(pos)
	add_child(bomb)
	var timer = Timer.new()
	timer.autostart = true
	timer.one_shot = true
	timer.wait_time = 3
	timer.connect("timeout", self, "_on_timer_timeout", [ pos ])
	add_child(timer)
	timer.start()
	
func _on_timer_timeout(pos):
	var explosion = explosion_scene.instance()
	explosion.set_position(pos)
	add_child(explosion)	
	explosion.init($Map.get_child(0), CENTER, 3, self)

func _on_connection_failed(error):
	print("Error while connecting to server " + error)
	
func _on_peer_packet_received(id, packet):
	var data = packet.get_string_from_ascii()
	print("Packet that contains data: " + data + " received")
	
	if (data == "start"): # the game has started
		$StartTimer.start()
	elif (data[0] == "0"): # start position received
		var info = data.split(",")
		$Player.start(start_positions[int(info[1])].position)
		get_tree().multiplayer.send_bytes("ready".to_ascii(), 1)
	elif (data[0] == "1"): # another player is in the game
		var info = data.split(",")
		var new_player = load("res://Scenes/Player.tscn").instance()
		new_player.set_name(info[2])
		$".".add_child(new_player)
		print(get_parent().get_children())
		get_node(info[2]).start(start_positions[int(info[1])].position)
		other_players.append(info[2])
	elif (data[0] == "2"):
		var info = data.split(",")
		print("Removing player with id " + str(info[1]))
		get_node(info[1]).hide()
		get_node(info[1]).queue_free()
		other_players.erase(info[1])
		
func _on_connection_succeeded():
	get_tree().multiplayer.send_bytes("need_pos".to_ascii(), 1)
