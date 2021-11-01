class_name RoomConnector
var consts = GameConsts.new()
var tile_setter = TileSetter.new()

func connect_rooms(level_size, rooms, map, tile_map):
	# Build an AStar graph of the area where we can add corridors
	var stone_graph = AStar.new()
	var point_id = 0
	for x in range(level_size.x):
		for y in range(level_size.y):
			if map[x][y] == consts.Tile.Stone:
				stone_graph.add_point(point_id,Vector3(x,y,0))
				
				# Connect to the left if it's also stone
				if x > 0 && map[x-1][y] == consts.Tile.Stone:
					var left_point = stone_graph.get_closest_point(Vector3(x-1,y,0))
					stone_graph.connect_points(point_id,left_point)
					
				# Connect to above if it's also stone
				if x > 0 && map[x][y-1] == consts.Tile.Stone:
					var above_point = stone_graph.get_closest_point(Vector3(x,y-1,0))
					stone_graph.connect_points(point_id,above_point)	
					
					
				point_id +=1
				
	# build an AStar fraph of room connections
	
	var room_graph = AStar.new()
	point_id = 0
	for room in rooms:
		var room_center = room.position + room.size / 2
		room_graph.add_point(point_id,Vector3(room_center.x, room_center.y,0))			
		point_id +=1
		
	# Add random connections until everyhthing is connected
	
	while !is_everything_connected(room_graph):
		add_random_connection(stone_graph, room_graph, rooms, map, tile_map)
		
		
func is_everything_connected(graph):
	var points = graph.get_points()
	var start = points.pop_back()
	for point in points:
		var path = graph.get_point_path(start, point)
		if !path:
			return false
	return true
	
func add_random_connection(stone_graph, room_graph, rooms, map, tile_map):
	# Pick rooms to connect

	var start_room_id = get_least_connected_point(room_graph)
	var end_room_id = get_nearest_unconnected_point(room_graph, start_room_id)
	
	# Pick door locations
	
	var start_position = pick_random_door_location(rooms[start_room_id])
	var end_position = pick_random_door_location(rooms[end_room_id])
	
	# Find a path to connect the doors to each other
	
	var closest_start_point = stone_graph.get_closest_point(start_position)
	var closest_end_point = stone_graph.get_closest_point(end_position)
	
	var path = stone_graph.get_point_path(closest_start_point, closest_end_point)
	assert(path)
	
	# Add path to the map
	
	path = Array(path)
	
	tile_setter.set_tile(start_position.x, start_position.y, consts.Tile.Door, map, tile_map)
	tile_setter.set_tile(end_position.x, end_position.y, consts.Tile.Door, map, tile_map)
	
	for position in path:
		tile_setter.set_tile(position.x, position.y, consts.Tile.Floor, map, tile_map)
	
	room_graph.connect_points(start_room_id, end_room_id)	


func get_least_connected_point(graph):
	var point_ids = graph.get_points()
	
	var least
	var tied_for_least = []
	
	for point in point_ids:
		var count = graph.get_point_connections(point).size()
		if !least || count < least:
			least = count
			tied_for_least = [point]
		elif count == least:
			tied_for_least.append(point)
			
	return tied_for_least[randi() % tied_for_least.size()]
	
func get_nearest_unconnected_point(graph, target_point):
	var target_position = graph.get_point_position(target_point)
	var point_ids = graph.get_points()
	
	var nearest
	var tied_for_nearest = []
	
	for point in point_ids:
		if point == target_point:
			continue
		
		var path = graph.get_point_path(point, target_point)
		if path:
			continue
			
		var dist = (graph.get_point_position(point) - target_position).length()
		if !nearest || dist < nearest:
			nearest = dist
			tied_for_nearest = [point]
		elif dist == nearest:
			tied_for_nearest.append(point)
			
	return tied_for_nearest[randi() % tied_for_nearest.size()]

func pick_random_door_location(room):
	var options = []
	
	# Top and bottom walls
	
	for x in range(room.position.x + 1, room.end.x - 2):
		options.append(Vector3(x, room.position.y, 0))
		options.append(Vector3(x, room.end.y - 1, 0))
			
	# Left and right walls
	
	for y in range(room.position.y + 1, room.end.y - 2):
		options.append(Vector3(room.position.x, y, 0))
		options.append(Vector3(room.end.x - 1, y, 0))
			
	return options[randi() % options.size()]

