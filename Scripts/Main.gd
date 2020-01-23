extends Node2D

enum {CENTER, UP, DOWN, LEFT, RIGHT}

var bomb_scene
var explosion_scene

func _ready():
	bomb_scene = preload("res://Scenes/Bomb.tscn")
	explosion_scene = preload("res://Scenes/Explosion.tscn")

func new_game(map):
	$Player.start($StartPositionPlayer1.position);
	$Player2.start($StartPositionPlayer2.position); # for testing purposes
	$StartTimer.start()
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
	