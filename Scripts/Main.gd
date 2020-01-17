extends Node2D

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

# WIP - fix stuff please
func _on_Player_bomb_placed(pos):
	var scene = load("res://Scenes/Bomb.tscn")
	var scene_insance = scene.instance()
	scene_insance.set_name("Bomb")
	add_child(scene_insance)
	$Bomb.position = pos