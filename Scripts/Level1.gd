extends Node2D

func new_game():
	$Player.start($StartPositionPlayer1.position);
	$StartTimer.start()
	$Map1.show_map()
	$HUD.show_message("Get Ready")

func _on_StartTimer_timeout():
	$Player.enable_controls()
	$HUD.hide_message()