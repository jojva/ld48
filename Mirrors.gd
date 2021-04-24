extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Circuit_tile_clicked(pos):
	var mirror_present = get_cellv(pos) == 0
	var mirror_flip = is_cell_x_flipped(pos.x, pos.y)
	if not mirror_present:
		set_cellv(pos, 0)
	else:
		if not mirror_flip:
			set_cellv(pos, 0, true)
		else:
			set_cellv(pos, -1)
