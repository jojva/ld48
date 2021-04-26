extends Node2D


var current_face = 0
var level_window = 0


func _ready():
	$ViewportContainer.margin_left = 100
	$ViewportContainer.margin_top = 100
	$ViewportContainer/Viewport.size = Vector2(320, 640)
	$ViewportContainer/Viewport/Tower.scale = Vector2(2, 2)
	$HUD/LevelLabels/TopLevel.text = str(level_window)
	$HUD/LevelLabels/BottomLevel.text = str(level_window + 1)


func _input(e):
	if e.is_action_pressed("ui_up"):
		look_up_down(-1)
	if e.is_action_pressed("ui_down"):
		look_up_down(1)
	if e.is_action_pressed("ui_look_left"):
		look_left_right(-1)
	if e.is_action_pressed("ui_look_right"):
		look_left_right(1)


func look_up_down(direction):
	var tower = $ViewportContainer/Viewport/Tower
	tower.current_level += direction
	tower.current_level = clamp(tower.current_level, 0, tower.nb_levels() - 1)
	if (direction == -1 and tower.current_level < level_window)	or (direction ==  1 and tower.current_level > level_window + 1):
		level_window += direction
		tower.position.y = - level_window * Constants.ROWS * Constants.CELL_SIZE * $ViewportContainer/Viewport/Tower.scale.y
		$HUD/LevelLabels/TopLevel.text = str(level_window)
		$HUD/LevelLabels/BottomLevel.text = str(level_window + 1)
	$HUD/HighlightedLevel.rect_position.y = $ViewportContainer.margin_top + (tower.current_level - level_window) * Constants.ROWS * Constants.CELL_SIZE * $ViewportContainer/Viewport/Tower.scale.y


func look_left_right(direction):
	current_face = (current_face + direction + 4) % 4
	$ViewportContainer/Viewport/Tower.position.x = \
		- current_face * Constants.COLS * Constants.CELL_SIZE * $ViewportContainer/Viewport/Tower.scale.x
	$HUD/Eye.rotate(direction * PI / 2)
