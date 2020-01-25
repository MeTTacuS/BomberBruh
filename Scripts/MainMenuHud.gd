extends CanvasLayer

signal start_game_map_1
signal start_game_map_2

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()

func _on_StartMap1_pressed():
	$StartMap1.hide()
	$StartMap2.hide()
	emit_signal("start_game_map_1")	

func hide_message():
	$MessageLabel.hide()

func _on_StartMap2_pressed():
	$StartMap1.hide()
	$StartMap2.hide()
	emit_signal("start_game_map_2")
