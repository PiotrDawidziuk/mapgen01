class_name TileSetter

# function for setting tiles in 
func set_tile(x,y,type,map, tile_map):
	# set in map which is array of arrays that holds the type of each tile
	map[x][y] = type
	# set tile in tile_map object, actually changes tiles in the game 
	tile_map.set_cell(x,y,type)
