extends CanvasLayer

signal start_game


func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()

func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")

func hide_message():
	$MessageLabel.hide()
