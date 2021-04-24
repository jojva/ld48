extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_cell(x, y, branches):
	var bits = 0
	for i in range(4):
		if branches[i]:
			bits += pow(2, i)
	set_cell(x, y, bits)
