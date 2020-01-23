extends Node2D

enum {CENTER, UP, DOWN, LEFT, RIGHT}

var tiles
var explosion_scene

func _ready():
	explosion_scene = load("res://Scenes/Explosion.tscn")
	$Timer.start()

func init(tilemap, direction, strength, daddy):
	tiles = tilemap
	if direction == CENTER:
		explosion_center(strength, daddy)
		
	if direction == UP:
		explosion_up(strength, daddy)
			
	if direction == DOWN:
		explosion_down(strength, daddy)
		
	if direction == LEFT:
		explosion_left(strength, daddy)
	
	if direction == RIGHT:
		explosion_right(strength, daddy)

func _on_Timer_timeout():
	$".".hide()
	$".".queue_free()
	
func create_explosion(pos, direction, strength, daddy):
	var explosion = explosion_scene.instance()
	explosion.set_position(pos)
	daddy.add_child(explosion)
	explosion.init(tiles, direction, strength, daddy)	

func explosion_center(strength, daddy):
	var texture = load("res://Sprites/Bomb/e_center.png")
	$Sprite.texture = texture
	# Right
	var pos_to_check = Vector2(position.x + 32, position.y)
	var cord = tiles.world_to_map(pos_to_check)
	var cell = tiles.get_cell(cord.x, cord.y)
	if cell == 1:
		tiles.set_cell(cord.x, cord.y, -1)
		create_explosion(pos_to_check, RIGHT, 1, daddy)
	elif cell == -1:
		tiles.set_cell(cord.x, cord.y, -1)
		create_explosion(pos_to_check, RIGHT, strength - 1, daddy)
	# Left
	pos_to_check = Vector2(position.x - 32, position.y)
	cord = tiles.world_to_map(pos_to_check)
	cell = tiles.get_cell(cord.x, cord.y)
	if cell == 1:
		tiles.set_cell(cord.x, cord.y, -1)
		create_explosion(pos_to_check, LEFT, 1, daddy)
	elif cell == -1:
		tiles.set_cell(cord.x, cord.y, -1)
		create_explosion(pos_to_check, LEFT, strength - 1, daddy)
	# Up
	pos_to_check = Vector2(position.x, position.y - 32)
	cord = tiles.world_to_map(pos_to_check)
	cell = tiles.get_cell(cord.x, cord.y)
	if cell == 1:
		tiles.set_cell(cord.x, cord.y, -1)
		create_explosion(pos_to_check, UP, 1, daddy)
	elif cell == -1:
		tiles.set_cell(cord.x, cord.y, -1)
		create_explosion(pos_to_check, UP, strength - 1, daddy)
	# Down
	pos_to_check = Vector2(position.x, position.y + 32)
	cord = tiles.world_to_map(pos_to_check)
	cell = tiles.get_cell(cord.x, cord.y)
	if cell == 1:
		tiles.set_cell(cord.x, cord.y, -1)
		create_explosion(pos_to_check, DOWN, 1, daddy)
	elif cell == -1:
		tiles.set_cell(cord.x, cord.y, -1)
		create_explosion(pos_to_check, DOWN, strength - 1, daddy)
		
func explosion_up(strength, daddy):
	var pos_to_check = Vector2(position.x, position.y - 32)
	var cord = tiles.world_to_map(pos_to_check)
	var cell = tiles.get_cell(cord.x, cord.y)
	if strength > 1:
		if cell == 1:
			tiles.set_cell(cord.x, cord.y, -1)
			var texture = load("res://Sprites/Bomb/e_vertical.png")
			$Sprite.texture = texture
			create_explosion(pos_to_check, UP, 1, daddy)
		elif cell == -1:
			var texture = load("res://Sprites/Bomb/e_vertical.png")
			$Sprite.texture = texture
			create_explosion(pos_to_check, UP, strength - 1, daddy)
		elif cell == 0 || cell == 2:
			var texture = load("res://Sprites/Bomb/e_top.png")
			$Sprite.texture = texture
	else:
		var texture = load("res://Sprites/Bomb/e_top.png")
		$Sprite.texture = texture

func explosion_down(strength, daddy):
	var pos_to_check = Vector2(position.x, position.y + 32)
	var cord = tiles.world_to_map(pos_to_check)
	var cell = tiles.get_cell(cord.x, cord.y)
	if strength > 1:
		if cell == 1:
			tiles.set_cell(cord.x, cord.y, -1)
			var texture = load("res://Sprites/Bomb/e_vertical.png")
			$Sprite.texture = texture
			create_explosion(pos_to_check, DOWN, 1, daddy)
		elif cell == -1:
			var texture = load("res://Sprites/Bomb/e_vertical.png")
			$Sprite.texture = texture
			create_explosion(pos_to_check, DOWN, strength - 1, daddy)
		elif cell == 0 || cell == 2:
			var texture = load("res://Sprites/Bomb/e_bottom.png")
			$Sprite.texture = texture
	else:
		var texture = load("res://Sprites/Bomb/e_bottom.png")
		$Sprite.texture = texture
			
func explosion_left(strength, daddy):
	var pos_to_check = Vector2(position.x - 32, position.y)
	var cord = tiles.world_to_map(pos_to_check)
	var cell = tiles.get_cell(cord.x, cord.y)
	if strength > 1:
		if cell == 1:
			tiles.set_cell(cord.x, cord.y, -1)
			var texture = load("res://Sprites/Bomb/e_horizontal.png")
			$Sprite.texture = texture
			create_explosion(pos_to_check, LEFT, 1, daddy)
		elif cell == -1:
			var texture = load("res://Sprites/Bomb/e_horizontal.png")
			$Sprite.texture = texture
			create_explosion(pos_to_check, LEFT, strength - 1, daddy)
		elif cell == 0 || cell == 2:
			var texture = load("res://Sprites/Bomb/e_left.png")
			$Sprite.texture = texture
	else:
		var texture = load("res://Sprites/Bomb/e_left.png")
		$Sprite.texture = texture
			
func explosion_right(strength, daddy):
	var pos_to_check = Vector2(position.x + 32, position.y)
	var cord = tiles.world_to_map(pos_to_check)
	var cell = tiles.get_cell(cord.x, cord.y)
	if strength > 1:
		if cell == 1:
			tiles.set_cell(cord.x, cord.y, -1)
			var texture = load("res://Sprites/Bomb/e_horizontal.png")
			$Sprite.texture = texture
			create_explosion(pos_to_check, RIGHT, 1, daddy)
		elif cell == -1:
			var texture = load("res://Sprites/Bomb/e_horizontal.png")
			$Sprite.texture = texture
			create_explosion(pos_to_check, RIGHT, strength - 1, daddy)
		elif cell == 0 || cell == 2:
			var texture = load("res://Sprites/Bomb/e_right.png")
			$Sprite.texture = texture
	else:
		var texture = load("res://Sprites/Bomb/e_right.png")
		$Sprite.texture = texture