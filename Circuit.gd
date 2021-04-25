extends TileMap

signal tile_clicked(pos)

enum CircuitTile {
	Empty = -1,
	Plus,
	Tee,
	Elbow,
	Straight,
}


func _input(e):
	if e is InputEventMouseButton \
	and e.button_index == BUTTON_LEFT \
	and e.is_pressed():
		var pos = world_to_map(to_local(e.position))
		if (get_cellv(pos) in [CircuitTile.Plus, CircuitTile.Tee]):
			emit_signal("tile_clicked", pos)
