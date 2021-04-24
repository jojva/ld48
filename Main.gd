extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum Directions {
	RIGHT,
	UP,
	LEFT,
	DOWN
}

const directions_vec = [
	Vector2(1, 0),
	Vector2(0, -1),
	Vector2(-1, 0),
	Vector2(0, 1),
]
# Called when the node enters the scene tree for the first time.
func _ready():
	update_light()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

const ROWS = 5
const COLS = 20
const START_X = 0
const START_Y = 0

func _on_Circuit_tile_clicked_everything(pos):
	var tile = $Circuit.get_cellv(pos)
	print("transposed: ", $Circuit.is_cell_transposed(pos.x, pos.y))
	print("flipped x : ", $Circuit.is_cell_x_flipped(pos.x, pos.y))
	print("flipped y : ", $Circuit.is_cell_y_flipped(pos.x, pos.y))
	

func step(pos, direction):
	return pos + directions_vec[direction]
	
const light_output = [
	[Directions.RIGHT, Directions.UP, Directions.LEFT, Directions.DOWN], # Plus
	[			   -1, Directions.UP, 			   -1, Directions.DOWN], # Tee -|
	[			   -1, 			-1, Directions.UP, Directions.RIGHT], # Elbow /-
	[-1, Directions.UP, -1, Directions.DOWN], # Straight |
]

func propagate_light(pos, direction):
	var tile_type = $Circuit.get_cellv(pos)
	if tile_type == -1:
		return -1
	return light_output[tile_type][direction]

func update_light():
	var tile_light = {}
	for r in range(ROWS):
		for c in range(COLS):
			tile_light[Vector2(c, r)] = [false, false, false, false]
	var direction = Directions.DOWN
	var pos = Vector2(START_X, START_Y)
	while direction != -1:
		print (direction)
		if $Circuit.get_cellv(pos) != -1:
			tile_light[pos][(direction + 2) % 4] = true
		direction = propagate_light(pos, direction)
		if $Circuit.get_cellv(pos) != -1:
			tile_light[pos][direction] = true
		pos = step(pos, direction)
	for r in range(ROWS):
		for c in range(COLS):
			$Light.update_cell(c, r, tile_light[Vector2(c, r)])
	
	
