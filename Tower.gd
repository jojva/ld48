extends Node2D

signal game_won

const START_X = 2
const START_Y = 0
var TOTAL_ROWS = -42

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

var light_source_side = 1
var next_light_source_side = 1
var current_level = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	TOTAL_ROWS = Constants.ROWS * nb_levels()
	update_light()
	
func look_left_right(direction):
	direction *= -1
	if $Tween.is_active() or $LookTween.is_active():
		return
	var shift = direction * Constants.CELL_SIZE * Constants.COLS
	var old_x = null
	var new_x = null
	var x_computed = false
	for child in get_children():
		if "Level" in child.name:
			child.rollover(direction)
			if not x_computed:
				old_x = child.position.x
				new_x = old_x + shift
				x_computed = true
			$LookTween.interpolate_property(child,
				'position:x',
				old_x,
				new_x,
				0.2)
	$LookTween.interpolate_property($Light,
		'position:x',
		old_x,
		new_x,
		0.2)
	
	next_light_source_side = (light_source_side + direction + 4) % 4
	$LookTween.start()
	
func shift_left_right(direction):
	var lvl = get_node("Level" + str(current_level))
	lvl.shift(direction)
	if current_level == 0:
		next_light_source_side = (light_source_side + direction + 4) % 4
	#update_light()


	
func _input(e):
	if e.is_action_pressed("ui_left"):
		shift_left_right(-1)
	if e.is_action_pressed("ui_right"):
		shift_left_right(1)


func _on_Level_updated():
	update_light()


func _on_Tween_tween_all_completed():
	light_source_side = next_light_source_side
	update_light()
	$Light.show()


func nb_levels():
	var count = 0
	for child in get_children():
		if "Level" in child.name:
			count += 1
	return count


func update_light():
	var tile_light = {}
	for r in range(TOTAL_ROWS):
		for c in range(Constants.COLS * 4):
			tile_light[Vector2(c, r)] = [false, false, false, false]
	var direction = Directions.DOWN
	var pos = Vector2(START_X + Constants.COLS * light_source_side, START_Y)
	while direction != -1 and pos.y >= 0 and pos.y < TOTAL_ROWS:
		var level = get_level(pos)
		var res = level.propagate_light(pos, direction)
		tile_light[pos][(direction + 2) % 4] = res[0]
		direction = res[1]
		if direction != -1:
			tile_light[pos][direction] = true
		pos = step(pos, direction)
	for r in range(TOTAL_ROWS):
		for c in range(Constants.COLS * 4):
			$Light.update_cell(c, r, tile_light[Vector2(c, r)])
	if pos.y >= TOTAL_ROWS:
		emit_signal("game_won")


func get_level(pos):
	return get_node("Level" + str(int(pos.y / Constants.ROWS)))


func step(pos, direction):
	var new_pos = pos + directions_vec[direction]
	new_pos.x = int(new_pos.x + Constants.COLS * 4) % (Constants.COLS * 4)
	return new_pos



func _on_Tween_tween_started(object, key):
	$Light.hide()


func _on_LookTween_tween_all_completed():
	light_source_side = next_light_source_side
	update_light()
