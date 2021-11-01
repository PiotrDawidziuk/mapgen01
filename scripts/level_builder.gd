class_name LevelBuilder

var tile_setter = TileSetter.new()
var room_adder = RoomAdder.new()
var consts = GameConsts.new()
var room_connector = RoomConnector.new()

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
			
			
	# create a free region on the whole level, with 2 tile margin from the borders
	# this table has one element now and this element is the whole level
	var free_regions =[Rect2(Vector2(2,2), level_size - Vector2(4,4))]
	# see how many rooms do we need on this particular level of our dungeon
	var num_rooms = consts.LEVEL_ROOM_COUNTS[level_num]
	# add rooms until there is no free regions or we created all the rooms we needed for this level
	for i in range(num_rooms):
		room_adder.add_room(free_regions, rooms, map, tile_map)
		if free_regions.empty():
			break
	
	room_connector.connect_rooms(level_size, rooms, map, tile_map)
