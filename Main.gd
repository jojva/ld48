extends Node2D

const START_X = 0
const START_Y = 0
const NB_LEVELS = 2
var TOTAL_ROWS = Level.ROWS * NB_LEVELS

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


func _on_Level_updated():
	update_light()


func update_light():
	var tile_light = {}
	for r in range(TOTAL_ROWS):
		for c in range(Level.COLS):
			tile_light[Vector2(c, r)] = [false, false, false, false]
	var direction = Directions.DOWN
	var pos = Vector2(START_X, START_Y)
	while direction != -1 and pos.y >= 0 and pos.y < TOTAL_ROWS:
		var level = get_level(pos)
		var res = level.propagate_light(pos, direction)
		tile_light[pos][(direction + 2) % 4] = res[0]
		direction = res[1]
		if direction != -1:
			tile_light[pos][direction] = true
		pos = step(pos, direction)
	for r in range(TOTAL_ROWS):
		for c in range(Level.COLS):
			$Light.update_cell(c, r, tile_light[Vector2(c, r)])


func get_level(pos):
	return get_node("Level" + str(int(pos.y / Level.ROWS)))


func step(pos, direction):
	var new_pos = pos + directions_vec[direction]
	new_pos.x = int(new_pos.x + Level.COLS) % Level.COLS
	return new_pos
