extends Node2D

#objects created from other classes
var level_builder = LevelBuilder.new()
var consts = GameConsts.new()
var tile_setter = TileSetter.new()

#Current level
var level_num = 0
var map = []
var rooms = []
var level_size

#Node_refs

onready var tile_map = $TileMap
onready var player = $Player

# Game state

var player_tile
var score = 0

func _ready():
	OS.set_window_size(Vector2(1280,720))
	randomize()

	level_builder.build_level(rooms, map, tile_map, level_size, level_num)
	
	player_tile = get_node("Player").place_player(rooms)
	
	update_visuals()
	
func _input(event):
	if !event.is_pressed():
		return
	
	if event.is_action("Left"):
		try_move(-1,0)
	if event.is_action("Right"):
		try_move(1,0)
	if event.is_action("Up"):
		try_move(0,-1)
	if event.is_action("Down"):
		try_move(0,1)
		
func try_move(dx,dy):
	var x = player_tile.x + dx
	var y = player_tile.y + dy
	var tile_type = consts.Tile.Stone
	#if x >= 0 && x < level_size.x && y >= 0 && y <level_size.y:
	tile_type = map [x][y]
		
	match tile_type:
		consts.Tile.Floor:
				player_tile = Vector2(x,y)
			
		consts.Tile.Door: 
			tile_setter.set_tile(x,y,consts.Tile.Floor, map, tile_map)	
	update_visuals()

func update_visuals():

	player.position = player_tile * consts.TILE_SIZE
	yield(get_tree().create_timer(0.000001), "timeout")
