extends Node2D

#objects created from other classes
var levelBuilder = LevelBuilder.new()

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

	levelBuilder.build_level(rooms, map, tile_map, level_size, level_num)




