extends Node2D


var current_face = 0


func _input(e):
	if e.is_action_pressed("ui_look_left"):
		current_face = (current_face + 1) % 4
		$ViewportContainer/Viewport/Tower.position.x = \
			- current_face * Constants.COLS * Constants.CELL_SIZE * $ViewportContainer/Viewport/Tower.scale.x
	if e.is_action_pressed("ui_look_right"):
		current_face = (current_face + 3) % 4
		$ViewportContainer/Viewport/Tower.position.x = \
			- current_face * Constants.COLS * Constants.CELL_SIZE * $ViewportContainer/Viewport/Tower.scale.x
