class_name RoomAdder

var consts = GameConsts.new()
var tile_setter = TileSetter.new()

func add_room(free_regions, rooms, map, tile_map):
	
	#Get random region from list of regions, if there are more than 1, or the only one if there is only 1
	var region = free_regions[randi() % free_regions.size()]
		
	var size_x = consts.MIN_ROOM_DIMENSION 
	
	# if region is bigger than room minimal dimension, add random size x (but not more than the size x of the region)
	if region.size.x > consts.MIN_ROOM_DIMENSION:
		size_x += randi() % int(region.size.x - consts.MIN_ROOM_DIMENSION)
	
	# if region is bigger than room minimal dimension, add random size x (but not more than the size x of the region)
	var size_y = consts.MIN_ROOM_DIMENSION
	if region.size.y > consts.MIN_ROOM_DIMENSION:
		size_y += randi() % int(region.size.y - consts.MIN_ROOM_DIMENSION)
		
	# Constrain the room dimensions to the maximum room dimension from project constants
	size_x = min(size_x, consts.MAX_ROOM_DIMENSION)
	size_y = min(size_y, consts.MAX_ROOM_DIMENSION)
		
	# Set start x position for the room rect2D, then randomize if there is enough space
	var start_x = region.position.x
	if region.size.x > size_x:
		start_x += randi() % int(region.size.x - size_x)
		
	# Set start y position for the room rect2D, then randomize if there is enough space		
	var start_y = region.position.y
	if region.size.y > size_y:
		start_y += randi() % int(region.size.y - size_y)
		
	# create the actual room Rect2D. Start point (x and y) and size (x and y) 
	#that shows us where is the room and how big it is
	var room = Rect2(start_x, start_y, size_x, size_y)
	
	# add room to the rooms list 
	rooms.append(room)
	
	#create top and bottom walls of the room, 
	for x in range(start_x, start_x + size_x):
		tile_setter.set_tile(x, start_y, consts.Tile.Wall, map, tile_map)
		tile_setter.set_tile(x, start_y + size_y - 1, consts.Tile.Wall, map, tile_map)
	
	#create left and right wall of the room, ignore the first and last tiles that are set in previous loop	
	for y in range(start_y + 1, start_y + size_y - 1):
		tile_setter.set_tile(start_x, y, consts.Tile.Wall, map, tile_map)
		tile_setter.set_tile(start_x + size_x - 1, y, consts.Tile.Wall, map, tile_map)
		
	# create the floor of the room
		for x in range(start_x + 1, start_x + size_x - 1):
			tile_setter.set_tile(x, y, consts.Tile.Floor, map,tile_map)
			
	cut_regions(free_regions, room)

#functions that deletes regions of the map from the free regions list, so you don't build rooms on top of each other. 			
func cut_regions(free_regions, region_to_remove):
	
	# array of regions that are occupied by rooms, so they have to be removed from the list of free regions
	var removal_queue = []
	# regions added to the list (free parts of the regions that were removed)
	var addition_queue = []
	
	# if a region in free regions interects the newly created room from regions to remove (both are Rect2), 
	# delete it from the list
	for region in free_regions:
		if region.intersects(region_to_remove):
			removal_queue.append(region)
			
			# check for the leftover space on all sides of the new room
			var leftover_left = region_to_remove.position.x - region.position.x - 1
			var leftover_right = region.end.x - region_to_remove.end.x - 1
			var leftover_above = region_to_remove.position.y - region.position.y - 1
			var leftover_below = region.end.y - region_to_remove.end.y - 1
			
			#if there is leftover space on any side of the room, check if it's bigger than min room size 
			# and add it to the free regions list
			# regions can overlap
			if leftover_left >= consts.MIN_ROOM_DIMENSION:
				addition_queue.append(Rect2(region.position, Vector2(leftover_left, region.size.y)))
			if leftover_right >= consts.MIN_ROOM_DIMENSION:
				addition_queue.append(Rect2(Vector2(region_to_remove.end.x + 1, region.position.y), Vector2(leftover_right, region.size.y)))
			if leftover_above >= consts.MIN_ROOM_DIMENSION:
				addition_queue.append(Rect2(region.position, Vector2(region.size.x, leftover_above)))
			if leftover_below >= consts.MIN_ROOM_DIMENSION:
				addition_queue.append(Rect2(Vector2(region.position.x, region_to_remove.end.y + 1), Vector2(region.size.x, leftover_below)))
	
	# remove regions from free regions, if they are on removal queue			
	for region in removal_queue:
		free_regions.erase(region)
		
	# add regions to free regions if they are on the addition queue	
	for region in addition_queue:
		free_regions.append(region)
		
