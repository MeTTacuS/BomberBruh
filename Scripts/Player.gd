extends KinematicBody2D
signal hit
signal bomb_placed

export var speed = 120
var controls_enabled = false
var bombs = 1

func _ready():
	hide()

func _physics_process(delta):
	if controls_enabled:
		var velocity = Vector2()
				
		$AnimatedSprite.play()
		if velocity.x != 0:
			$AnimatedSprite.flip_h = velocity.x < 0
			
		if Input.is_action_pressed("ui_up"):
			velocity += Vector2(0, -1)
		if Input.is_action_pressed("ui_down"):
			velocity += Vector2(0, 1)
		if Input.is_action_pressed("ui_left"):
			velocity += Vector2(-1, 0)
		if Input.is_action_pressed("ui_right"):
			velocity += Vector2(1, 0)
		move_and_slide(velocity * speed)
		# Might be useful for detecting collision and stuff
#		for i in get_slide_count():
#			var collision = get_slide_collision(i)
			
			# Add bomb recharge logic
		if Input.is_action_just_pressed("ui_select"):
			emit_signal("bomb_placed", position)

func start(pos):
	position = pos
	show()

func enable_controls():
	controls_enabled = true
