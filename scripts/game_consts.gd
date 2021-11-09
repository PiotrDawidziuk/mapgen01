class_name GameConsts

const LEVEL_SIZES = [
	Vector2(30,30),
	Vector2(35,35),
	Vector2(40,40),
	Vector2(45,45),
	Vector2(50,50)
]

const TILE_SIZE = 32
const LEVEL_ROOM_COUNTS = [5,7,9,12,15]
const MIN_ROOM_DIMENSION = 5
const MAX_ROOM_DIMENSION = 8

enum Tile {Floor, Wall, Player, Door, Stone}
#enum Tile {Wall, Stone, Door, Floor, Player}
