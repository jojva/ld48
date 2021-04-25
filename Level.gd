extends Node2D
class_name Level


signal updated


const ROWS = 5
const COLS = 20


const light_input = [
	[true, true, true, true], # Plus
	[true, true, true, false], # Tee T
	[false, false, true, true], # Elbow L
	[true, false, true, false], # Straight -
]


const light_output = [
	[Directions.RIGHT, Directions.UP, Directions.LEFT, Directions.DOWN], # Plus
	[Directions.RIGHT, -1, 			   Directions.LEFT, -1], # Tee T
	[			   -1, 			-1, Directions.UP, Directions.RIGHT], # Elbow L
	[Directions.RIGHT, -1, Directions.LEFT, -1], # Straight -
]

var light_output_mirror = [
	[ # not flipped mirror : \
		[Directions.DOWN, Directions.LEFT, Directions.UP, Directions.RIGHT], # Plus
		[Directions.DOWN, Directions.LEFT, -1, -1],  # Tee T
	],
	[ # flipped mirror : /
		[Directions.UP, Directions.RIGHT, Directions.DOWN, Directions.LEFT], # Plus
		[-1, Directions.RIGHT, Directions.DOWN, -1],  # Tee T
	],
]


func propagate_light(pos, direction):
	pos.y = int(pos.y) % ROWS
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


func _on_Mirrors_updated_mirrors():
	emit_signal("updated")
