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

func step(pos, direction):
	var new_pos = pos + directions_vec[direction]
	new_pos.x = int(new_pos.x + COLS) % COLS
	return new_pos
	
const light_output = [
	[Directions.RIGHT, Directions.UP, Directions.LEFT, Directions.DOWN], # Plus
	[Directions.RIGHT, -1, 			   Directions.LEFT, -1], # Tee T
	[			   -1, 			-1, Directions.UP, Directions.RIGHT], # Elbow L
	[Directions.RIGHT, -1, Directions.LEFT, -1], # Straight -
]

const light_output_mirror = [
	[ # not flipped mirror : \
		[Directions.DOWN, Directions.LEFT, Directions.UP, Directions.RIGHT], # Plus
		[Directions.DOWN, Directions.LEFT, -1, -1],  # Tee T
	],
	[ # flipped mirror : /
		[Directions.UP, Directions.RIGHT, Directions.DOWN, Directions.LEFT], # Plus
		[-1, Directions.RIGHT, Directions.DOWN, -1],  # Tee T
	],

]

const light_input = [
	[true, true, true, true], # Plus
	[true, true, true, false], # Tee T
	[false, false, true, true], # Elbow L
	[true, false, true, false], # Straight -
]

func propagate_light(pos, direction):
	var tile_type = $Circuit.get_cellv(pos)
	var transposed: int = $Circuit.is_cell_transposed(pos.x, pos.y)
	var x_flipped = $Circuit.is_cell_x_flipped(pos.x, pos.y)
	var rotation = transposed + int(x_flipped) * 2
	if tile_type == -1:
		return [false, -1]
		
	var	output_matrix = light_output
	if tile_type in [$Circuit.CircuitTile.Plus, $Circuit.CircuitTile.Tee]:
		var mirror_state = $Mirrors.get_mirror_state(pos)
		if mirror_state[0]:
			output_matrix = light_output_mirror[int(mirror_state[1]) ^ transposed]

	direction = (direction - rotation + 4) % 4
	var out_direction = output_matrix[tile_type][direction]
	if out_direction != -1:
		out_direction += rotation
		out_direction %= 4
	return [
		light_input[tile_type][direction],
		 out_direction
	]

func update_light():
	var tile_light = {}
	for r in range(ROWS):
		for c in range(COLS):
			tile_light[Vector2(c, r)] = [false, false, false, false]
	var direction = Directions.DOWN
	var pos = Vector2(START_X, START_Y)
	while direction != -1:
		var res = propagate_light(pos, direction)
		tile_light[pos][(direction + 2) % 4] = res[0]
		direction = res[1]
		if direction != -1:
			tile_light[pos][direction] = true
		pos = step(pos, direction)
	for r in range(ROWS):
		for c in range(COLS):
			$Light.update_cell(c, r, tile_light[Vector2(c, r)])
	
	
func _on_Mirrors_updated_mirrors():
	update_light()
