extends Control

var level_scene = preload("res://PerspectiveLevel.tscn")
const LEVEL_PIXEL_HEIGHT = 32


var level_count = 6
var sprites

# Called when the node enters the scene tree for the first time.
func _ready():
	instanciate_levels()


func instanciate_levels():
	set_custom_minimum_size(Vector2(64, (level_count + 1) * LEVEL_PIXEL_HEIGHT))
	sprites = []
	sprites.resize(level_count)
	
	# Bottom
	var bottom = level_scene.instance()
	bottom.position = Vector2(0, (level_count - 1) * LEVEL_PIXEL_HEIGHT)
	bottom.flip_v = true
	add_child(bottom)
	
	for i in range(level_count, 0, -1):
		var current_level = i - 1
		var level = level_scene.instance()
		level.position = Vector2(0, current_level * LEVEL_PIXEL_HEIGHT)
		sprites[current_level] = level
		add_child(level)


func update_levels(direction, viewed_level, selected_level):
	for i in range(level_count, 0, -1):
		var current_level = i - 1
		var level = sprites[current_level]
		var viewed = viewed_level <= current_level and current_level <= viewed_level + 1
		var selected = selected_level == current_level
		level.frame_coords.y = direction
		level.frame_coords.x = int(viewed) + int(selected)
