extends Node2D

func _ready():
	$AnimatedSprite.play()
	$ExplosionTimer.start()

func _on_ExplosionTimer_timeout():
	$".".hide()
	$".".queue_free()