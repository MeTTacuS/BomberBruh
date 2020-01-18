extends KinematicBody2D
signal bomb_placed

var speed = 120
var controls_enabled = false
var max_bombs = 2
var current_bombs = 2
var bomb_recharge_timer = 3
var recharge_timer

func _ready():
	recharge_timer = get_tree().create_timer(0.0)
	hide()

func _physics_process(delta):
	# Make it so that multiple timers spawn
	print(current_bombs)
	if !(current_bombs >= max_bombs):
		if recharge_timer.time_left <= 0.0:
			recharge_timer = get_tree().create_timer(bomb_recharge_timer)
			yield(recharge_timer, "timeout")
			current_bombs += 1
			
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
			
		if Input.is_action_just_pressed("ui_select") && current_bombs != 0 && current_bombs <= max_bombs:
			current_bombs -= 1
			emit_signal("bomb_placed", position)

func start(pos):
	position = pos
	show()

func enable_controls():
	controls_enabled = true
