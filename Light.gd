extends TileMap


func update_cell(x, y, branches):
	x = x - position.x / Constants.CELL_SIZE
	var bits = 0
	for i in range(4):
		if branches[i]:
			bits += pow(2, i)
	set_cell(x, y, bits)
