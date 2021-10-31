class_name RoomAdder

var consts = GameConsts.new()
var tile_setter = TileSetter.new()

func add_room(free_regions, rooms, map, tile_map):
	var region = free_regions[randi() % free_regions.size()]
		
	var size_x = consts.MIN_ROOM_DIMENSION 
	if region.size.x > consts.MIN_ROOM_DIMENSION:
		size_x += randi() % int(region.size.x - consts.MIN_ROOM_DIMENSION)
	
	var size_y = consts.MIN_ROOM_DIMENSION
	if region.size.y > consts.MIN_ROOM_DIMENSION:
		size_y += randi() % int(region.size.y - consts.MIN_ROOM_DIMENSION)
		
	size_x = min(size_x, consts.MAX_ROOM_DIMENSION)
	size_y = min(size_y, consts.MAX_ROOM_DIMENSION)
		
	var start_x = region.position.x
	if region.size.x > size_x:
		start_x += randi() % int(region.size.x - size_x)
		
	var start_y = region.position.y
	if region.size.y > size_y:
		start_y += randi() % int(region.size.y - size_y)
	
	var room = Rect2(start_x, start_y, size_x, size_y)
	rooms.append(room)
	
	for x in range(start_x, start_x + size_x):
		tile_setter.set_tile(x, start_y, consts.Tile.Wall, map, tile_map)
		tile_setter.set_tile(x, start_y + size_y - 1, consts.Tile.Wall, map, tile_map)
		
	for y in range(start_y + 1, start_y + size_y - 1):
		tile_setter.set_tile(start_x, y, consts.Tile.Wall, map, tile_map)
		tile_setter.set_tile(start_x + size_x - 1, y, consts.Tile.Wall, map, tile_map)
		
		for x in range(start_x + 1, start_x + size_x - 1):
			tile_setter.set_tile(x, y, consts.Tile.Floor, map,tile_map)
			
	cut_regions(free_regions, room)
			
func cut_regions(free_regions, region_to_remove):
	var removal_queue = []
	var addition_queue = []
	
	for region in free_regions:
		if region.intersects(region_to_remove):
			removal_queue.append(region)
			
			var leftover_left = region_to_remove.position.x - region.position.x - 1
			var leftover_right = region.end.x - region_to_remove.end.x - 1
			var leftover_above = region_to_remove.position.y - region.position.y - 1
			var leftover_below = region.end.y - region_to_remove.end.y - 1
			
		
			if leftover_left >= consts.MIN_ROOM_DIMENSION:
				addition_queue.append(Rect2(region.position, Vector2(leftover_left, region.size.y)))
			if leftover_right >= consts.MIN_ROOM_DIMENSION:
				addition_queue.append(Rect2(Vector2(region_to_remove.end.x + 1, region.position.y), Vector2(leftover_right, region.size.y)))
			if leftover_above >= consts.MIN_ROOM_DIMENSION:
				addition_queue.append(Rect2(region.position, Vector2(region.size.x, leftover_above)))
			if leftover_below >= consts.MIN_ROOM_DIMENSION:
				addition_queue.append(Rect2(Vector2(region.position.x, region_to_remove.end.y + 1), Vector2(region.size.x, leftover_below)))
				
	for region in removal_queue:
		free_regions.erase(region)
		
	for region in addition_queue:
		free_regions.append(region)
		
