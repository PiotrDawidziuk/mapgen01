class_name RoomSizeCreator

var consts = GameConsts.new()

func get_size_x(region):
	
	# get minimal room size from consts
	var size = consts.MIN_ROOM_DIMENSION 
	
	# if region is bigger than room minimal dimension, add random size x (but not more than the size x of the region)
	if region.size.x > consts.MIN_ROOM_DIMENSION:
		size += randi() % int(region.size.x - consts.MIN_ROOM_DIMENSION)
		
	# Constrain the room dimensions to the maximum room dimension from project constants
	size = min(size, consts.MAX_ROOM_DIMENSION)
	
	return size

func get_size_y(region):
	
	# get minimal room size from consts
	var size = consts.MIN_ROOM_DIMENSION 
	
	# if region is bigger than room minimal dimension, add random size y(but not more than the size y of the region)
	if region.size.y > consts.MIN_ROOM_DIMENSION:
		size += randi() % int(region.size.y - consts.MIN_ROOM_DIMENSION)
		
	# Constrain the room dimensions to the maximum room dimension from project constants
	size = min(size, consts.MAX_ROOM_DIMENSION)
	
	return size
