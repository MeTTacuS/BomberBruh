extends Node2D

enum {CENTER, UP, DOWN, LEFT, RIGHT}

var direction
var tiles
var strength

func _ready():
#	$AnimatedSprite.play()
	$Timer.start()

func init(tilemap, direction, strength):
	tiles = tilemap
	# set sprite based on direction and strength
	var pos_to_check = Vector2(position.x + 16, position.y)
	var cord = tiles.world_to_map(pos_to_check)
	var cell = tiles.get_cell(cord.x, cord.y)
	if cell == 1:
		tiles.set_cell(cord.x, cord.y, -1)
	pos_to_check = Vector2(position.x, position.y + 16)
	cord = tiles.world_to_map(pos_to_check)
	cell = tiles.get_cell(cord.x, cord.y)
	if cell == 1:
		tiles.set_cell(cord.x, cord.y, -1)
	pos_to_check = Vector2(position.x, position.y - 16)
	cord = tiles.world_to_map(pos_to_check)
	cell = tiles.get_cell(cord.x, cord.y)
	if cell == 1:
		tiles.set_cell(cord.x, cord.y, -1)
	pos_to_check = Vector2(position.x - 16, position.y)
	cord = tiles.world_to_map(pos_to_check)
	cell = tiles.get_cell(cord.x, cord.y)
	if cell == 1:
		tiles.set_cell(cord.x, cord.y, -1)

func _on_Timer_timeout():
	$".".hide()
	$".".queue_free()