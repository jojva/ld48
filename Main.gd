extends Node2D


onready var game = $HUD/MarginContainer/ColorRect/MarginContainer/HBoxContainer
onready var viewport_container = game.get_node("ViewportContainer")
onready var viewport = viewport_container.get_node("Viewport")
onready var tower = viewport.get_node("Tower")
onready var level_labels = game.get_node("LevelLabels")
onready var highlighted_level = viewport.get_node("HighlightedLevel")
onready var eye = game.get_node("VBoxContainer/CenterContainer3/VBoxContainer/CenterContainer/HBoxContainer/Eye")

var current_face = 0
var level_window = 0


func _ready():
	viewport_container.margin_left = 96
	viewport_container.margin_top = 96
	viewport.size = Vector2(320, 640)
	tower.scale = Vector2(2, 2)
	update_level_labels()


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
	tower.current_level += direction
	tower.current_level = clamp(tower.current_level, 0, tower.nb_levels() - 1)
	if (direction == -1 and tower.current_level < level_window)	or (direction ==  1 and tower.current_level > level_window + 1):
		level_window += direction
		tower.position.y = - level_window * Constants.ROWS * Constants.CELL_SIZE * tower.scale.y
		update_level_labels()
	highlighted_level.rect_position.y = viewport_container.margin_top + (tower.current_level - level_window) * Constants.ROWS * Constants.CELL_SIZE * tower.scale.y


func look_left_right(direction):
	current_face = (current_face + direction + 4) % 4
	tower.position.x = - current_face * Constants.COLS * Constants.CELL_SIZE * tower.scale.x
	eye.set_rotation(current_face * PI / 2)


func update_level_labels():
	level_labels.get_node("TopLevel").text = str(level_window + 1)
	level_labels.get_node("BottomLevel").text = str(level_window + 2)


func _on_TurnLeft_pressed():
	pass # Replace with function body.


func _on_TurnRight_pressed():
	pass # Replace with function body.


func _on_GoUp_pressed():
	pass # Replace with function body.


func _on_ShiftLeft_pressed():
	pass # Replace with function body.


func _on_GoDown_pressed():
	pass # Replace with function body.


func _on_ShiftRight_pressed():
	pass # Replace with function body.
