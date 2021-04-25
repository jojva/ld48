extends TileMap

signal updated_mirrors


func _on_Circuit_tile_clicked(pos):
	var mirror_state = get_mirror_state(pos)
	var mirror_present = mirror_state[0]
	var mirror_flip = mirror_state[1]
	if not mirror_present:
		set_cellv(pos, 0)
	else:
		if not mirror_flip:
			set_cellv(pos, 0, true)
		else:
			set_cellv(pos, -1)
	emit_signal("updated_mirrors")


func get_mirror_state(pos):
	var mirror_present = get_cellv(pos) == 0
	var mirror_flip = is_cell_x_flipped(pos.x, pos.y)
	return [mirror_present, mirror_flip]
