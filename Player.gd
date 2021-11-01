extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
	
	
	#Place player 
func place_player(rooms):
	var start_room = rooms.front()
	var player_x = start_room.position.x + 1 + randi() % int(start_room.size.x -2)
	var player_y = start_room.position.y + 1 + randi() % int(start_room.size.y -2)
	var player_tile = Vector2(player_x, player_y)
	return player_tile
