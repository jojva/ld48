extends Node2D


var current_face = 0


func _input(e):
	if e.is_action_pressed("ui_look_left"):
		look_elsewhere(1)
	if e.is_action_pressed("ui_look_right"):
		look_elsewhere(-1)


func look_elsewhere(direction):
	current_face = (current_face + direction + 4) % 4
	$ViewportContainer/Viewport/Tower.position.x = \
		- current_face * Constants.COLS * Constants.CELL_SIZE * $ViewportContainer/Viewport/Tower.scale.x
	$HUD/Eye.rotate(direction * PI / 2)
