extends KinematicBody2D
signal bomb_placed

export var speed = 120
export var bomb_recharge_timer = 3
var controls_enabled = false
var max_bombs = 2
var current_bombs
var can_get_hit = true # workaround for unknown CollisionShape2D not being disabled issue

var hp = 3

func _ready():
	current_bombs = 2
	hide()

func _physics_process(delta):			
	if controls_enabled:
		var velocity = Vector2()
				
		$AnimatedSprite.play()
		if velocity.x != 0:
			$AnimatedSprite.flip_h = velocity.x < 0
			
		velocity = get_player_input(velocity)
		move_and_slide(velocity * speed)
			
		if Input.is_action_just_pressed("ui_select") && current_bombs != 0 && current_bombs <= max_bombs:
			handle_bomb_placement()

func get_player_input(velocity):
	if Input.is_action_pressed("ui_up"):
		velocity += Vector2(0, -1)
	if Input.is_action_pressed("ui_down"):
		velocity += Vector2(0, 1)
	if Input.is_action_pressed("ui_left"):
		velocity += Vector2(-1, 0)
	if Input.is_action_pressed("ui_right"):
		velocity += Vector2(1, 0)
	return velocity

func handle_bomb_placement():
	current_bombs -= 1
	var timer = Timer.new()
	timer.autostart = true
	timer.one_shot = true
	timer.wait_time = bomb_recharge_timer
	timer.connect("timeout", self, "_on_timer_timeout")
	add_child(timer)
	timer.start()
	var bomb_position = get_bomb_position(position)
	emit_signal("bomb_placed", bomb_position)

func start(pos):
	position = pos
	show()

func enable_controls():
	controls_enabled = true
	
func _on_timer_timeout():
	current_bombs += 1
	
func get_bomb_position(position):
	var pos_x = int(position.x / 32) * 32 + 16
	var pos_y = int(position.y / 32) * 32 + 16
	return Vector2(pos_x, pos_y)

func lower_hp():
	if can_get_hit:
		can_get_hit = false
		hp -= 1
		$AnimatedSprite
		var timer = Timer.new()
		timer.autostart = true
		timer.one_shot = true
		timer.wait_time = 1
		timer.connect("timeout", self, "_on_immunity_timer_timeout")
		add_child(timer)
		timer.start()
		if hp == 0:
			$".".hide()
			$".".queue_free()
		return hp
	else:
		return -1

func _on_immunity_timer_timeout():
	can_get_hit = true