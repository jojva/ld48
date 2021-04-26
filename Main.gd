extends Node2D


onready var game = $HUD/MarginContainer/ColorRect/MarginContainer/HBoxContainer
onready var container = game.get_node("Container/Node2D")
onready var tower = container.get_node("Tower")
onready var level_labels = game.get_node("LevelLabels")
onready var highlighted_level = container.get_node("HighlightedLevel")
onready var eye = game.get_node("VBoxContainer/CenterContainer3/VBoxContainer/CenterContainer/HBoxContainer/Eye")
onready var winner = game.get_node("VBoxContainer/Winner")
onready var timer = game.get_node("VBoxContainer/Timer")

var current_face = 0
var level_window = 0


func _ready():
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
	if (direction == -1 and tower.current_level < level_window) or (direction ==  1 and tower.current_level > level_window + 1):
		level_window += direction
		tower.position.y = - level_window * Constants.ROWS * Constants.CELL_SIZE * tower.scale.y
		update_level_labels()
	highlighted_level.rect_position.y = (tower.current_level - level_window) * Constants.ROWS * Constants.CELL_SIZE * tower.scale.y + 2


func look_left_right(direction):
	current_face = (current_face + direction + 4) % 4
	tower.position.x = - current_face * Constants.COLS * Constants.CELL_SIZE * tower.scale.x
	eye.set_rotation(current_face * PI / 2)


func update_level_labels():
	level_labels.get_node("TopLevel").text = str(level_window + 1)
	level_labels.get_node("BottomLevel").text = str(level_window + 2)


func _on_TurnLeft_pressed():
	look_left_right(-1)


func _on_TurnRight_pressed():
	look_left_right(1)


func _on_GoUp_pressed():
	look_up_down(-1)


func _on_ShiftLeft_pressed():
	tower.shift_left_right(-1)


func _on_GoDown_pressed():
	look_up_down(1)


func _on_ShiftRight_pressed():
	tower.shift_left_right(1)


func _on_Timer_timeout():
	if winner.text == "WINNER":
		winner.text = "winner"
	else:
		winner.text = "WINNER"


func _on_Tower_game_won():
	winner.show()
