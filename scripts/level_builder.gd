extends Node

class_name LevelBuilder

var tile_setter = TileSetter.new()
var room_adder = RoomAdder.new()
var consts = GameConsts.new()

func build_level(rooms, map, tile_map, level_size, level_num):
	# start with blank map
	
	rooms.clear()
	map.clear()
	tile_map.clear()
	
	level_size = consts.LEVEL_SIZES[level_num]
	for x in range (level_size.x):
		map.append([])
		for y in range (level_size.y):
			map[x].append(consts.Tile.Stone)
			tile_map.set_cell(x,y,consts.Tile.Stone)
			
			
			
	var free_regions =[Rect2(Vector2(2,2), level_size - Vector2(4,4))]
	var num_rooms = consts.LEVEL_ROOM_COUNTS[level_num]
	for i in range(num_rooms):
		room_adder.add_room(free_regions, rooms, map, tile_map)
		if free_regions.empty():
			break



