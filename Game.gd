extends Node2D

# constants to be moved to another class

const TILE_SIZE = 32

const LEVEL_SIZES = [
	Vector2(30,30),
	Vector2(35,35),
	Vector2(40,40),
	Vector2(45,45),
	Vector2(50,50)
]

const LEVEL_ROOM_COUNTS = [5,7,9,12,15]
const MIN_ROOM_DIMENSION = 5
const MAX_ROOM_DIMENSION = 8

enum Tile {Door, Floor, Player, Wall}

#Current level
var level_num = 0
var map = []
var rooms = []
var level_size

#Node_refs

onready var tile_map = $TileMap
onready var player = $Player

func _ready():
	OS.set_window_size(Vector2(1280,720))
