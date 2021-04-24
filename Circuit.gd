extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


signal tile_clicked(pos)
signal tile_clicked_everything(pos)
enum CircuitTile {
	Empty = -1,
	Plus,
	Tee,
	Elbow,
	Straight,
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(e):
	if e is InputEventMouseButton \
	and e.button_index == BUTTON_LEFT \
	and e.is_pressed():
		var pos = world_to_map(to_local(e.position))
		if (get_cellv(pos) in [CircuitTile.Plus, CircuitTile.Tee]):
			emit_signal("tile_clicked", pos)
		emit_signal("tile_clicked_everything", pos)
		#set_cellv(pos, (get_cellv(pos) + 1) % 4)


