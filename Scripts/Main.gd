extends Node2D

var bomb_scene

func _ready():
	bomb_scene = preload("res://Scenes/Bomb.tscn")	

func new_game(map):
	$Player.start($StartPositionPlayer1.position);
	$StartTimer.start()
	if map == 1:
		var scene = load("res://Scenes/Map1.tscn")
		var scene_insance = scene.instance()
		scene_insance.set_name("Map")
		add_child(scene_insance)
	elif map == 2:
		var scene = load("res://Scenes/Map2.tscn")
		var scene_insance = scene.instance()
		scene_insance.set_name("Map")
		add_child(scene_insance)
	$HUD.show_message("Get Ready")

func _on_StartTimer_timeout():
	$Player.enable_controls()
	$HUD.hide_message()

func _on_Player_bomb_placed(pos):
	var scene_insance = bomb_scene.instance()
	scene_insance.set_position(pos)
	add_child(scene_insance)
	