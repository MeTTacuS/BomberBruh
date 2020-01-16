extends KinematicBody2D
signal hit

export var speed = 120
var controls_enabled = false

func _ready():
	hide()

func _physics_process(delta):
	if controls_enabled:
		$AnimatedSprite.play()
		var velocity = Vector2()
		if Input.is_action_pressed("ui_up"):
			velocity += Vector2(0, -1)
		if Input.is_action_pressed("ui_down"):
			velocity += Vector2(0, 1)
		if Input.is_action_pressed("ui_left"):
			velocity += Vector2(-1, 0)
		if Input.is_action_pressed("ui_right"):
			velocity += Vector2(1, 0)
			
		move_and_slide(velocity * speed)
		for i in get_slide_count():
			var collision = get_slide_collision(i)

		# Flips the animation if going left
		if velocity.x != 0:
			$AnimatedSprite.flip_h = velocity.x < 0

func start(pos):
	position = pos
	show()

func enable_controls():
	controls_enabled = true

