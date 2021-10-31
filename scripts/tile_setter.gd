class_name TileSetter

func set_tile(x,y,type,map, tile_map):
	map[x][y] = type
	tile_map.set_cell(x,y,type)
