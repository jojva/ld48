extends Node2D


var current_face = 0
var level_window = 0


func _ready():
	$ViewportContainer.margin_left = 100
	$ViewportContainer.margin_top = 100
	$ViewportContainer/Viewport.size = Vector2(320, 640)
	$ViewportContainer/Viewport/Tower.scale = Vector2(2, 2)


func _input(e):
	var tower = $ViewportContainer/Viewport/Tower
	if e.is_action_pressed("ui_up"):
		tower.current_level = max(0, tower.current_level - 1)
		if tower.current_level < level_window:
			level_window -= 1
			tower.position.y = - level_window * Constants.ROWS * Constants.CELL_SIZE * $ViewportContainer/Viewport/Tower.scale.y
		$HUD/HighlightedLevel.rect_position.y = $ViewportContainer.margin_top + (tower.current_level - level_window) * Constants.ROWS * Constants.CELL_SIZE * $ViewportContainer/Viewport/Tower.scale.y
	if e.is_action_pressed("ui_down"):
		tower.current_level = min(tower.nb_levels() - 1, tower.current_level + 1)
		if tower.current_level > level_window + 1:
			level_window += 1
			tower.position.y = - level_window * Constants.ROWS * Constants.CELL_SIZE * $ViewportContainer/Viewport/Tower.scale.y
		$HUD/HighlightedLevel.rect_position.y = $ViewportContainer.margin_top + (tower.current_level - level_window) * Constants.ROWS * Constants.CELL_SIZE * $ViewportContainer/Viewport/Tower.scale.y
	if e.is_action_pressed("ui_look_left"):
		look_elsewhere(1)
	if e.is_action_pressed("ui_look_right"):
		look_elsewhere(-1)


func look_elsewhere(direction):
	current_face = (current_face + direction + 4) % 4
	$ViewportContainer/Viewport/Tower.position.x = \
		- current_face * Constants.COLS * Constants.CELL_SIZE * $ViewportContainer/Viewport/Tower.scale.x
	$HUD/Eye.rotate(direction * PI / 2)
