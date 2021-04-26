extends Node2D
class_name Level


signal updated


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
	pos = to_local_cell(pos)
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


func to_local_cell(pos):
	pos.x -= position.x / $Circuit.cell_size.x
	pos.y = int(pos.y) % Constants.ROWS
	return pos


func shift(direction):
	print("shifting")
	position.x += direction * Constants.COLS * $Circuit.cell_size.x
	var offset_src
	var offset_dst
	if direction > 0:
		offset_dst = Vector2(0, 0)
		offset_src = Vector2(Constants.COLS * 4, 0)
	else:
		offset_src = Vector2(-Constants.COLS, 0)
		offset_dst =Vector2(Constants.COLS * 3, 0)
	for r in range(Constants.ROWS):
		for c in range(Constants.COLS):
			var cursor = Vector2(c, r)
			move_cell($Wall, cursor + offset_src, cursor + offset_dst)
			move_cell($Circuit, cursor + offset_src, cursor + offset_dst)
			move_cell($Mirrors, cursor + offset_src, cursor + offset_dst)
			
func move_cell(tilemap: TileMap, src: Vector2, dst: Vector2):
	src = to_local_cell(src)
	dst = to_local_cell(dst)
	tilemap.set_cellv(
		dst,
		tilemap.get_cellv(src),
		tilemap.is_cell_x_flipped(src.x, src.y),
		tilemap.is_cell_y_flipped(src.x, src.y),
		tilemap.is_cell_transposed(src.x, src.y)
	)
	tilemap.set_cellv(src, -1)

func _on_Mirrors_updated_mirrors():
	emit_signal("updated")
