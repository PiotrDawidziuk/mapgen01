extends Node

class_name LevelBuilder

#constants for level building
const LEVEL_SIZES = [
	Vector2(30,30),
	Vector2(35,35),
	Vector2(40,40),
	Vector2(45,45),
	Vector2(50,50)
]

const TILE_SIZE = 32
const LEVEL_ROOM_COUNTS = [5,7,9,12,15]
const MIN_ROOM_DIMENSION = 5
const MAX_ROOM_DIMENSION = 8

enum Tile {Floor, Wall, Player, Door}

func build_level(rooms, map, tile_map, level_size, level_num):
	# start with blank map
	
	rooms.clear()
	map.clear()
	tile_map.clear()
	
	level_size = LEVEL_SIZES[level_num]
	for x in range (level_size.x):
		map.append([])
		for y in range (level_size.y):
			map[x].append(Tile.Wall)
			tile_map.set_cell(x,y,Tile.Wall)
