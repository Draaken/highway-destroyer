extends Node2D
@onready var tilemap: TileMap = $TileMap

var map_size = Vector2(20,10)

var cells: Array = []

var names = [
	"right_left",
	"top_down,",
	"turn_left_top",
	"turn_right_top",
	"turn_right_bottom",
	"turn_left_bottom",
	]
	
var tiles_data: Dictionary = {
	#[atlas_coord, alternative_tiles, weight]
	"right_left": [Vector2(0,0), 1],
	"top_down": [Vector2(1,0), 1],
	"turn_left_top": [Vector2(2,0), 0.2],
	"turn_right_top": [Vector2(2,0), 0.2],
	"turn_right_bottom": [Vector2(2,0), 0.2],
	"turn_left_bottom": [Vector2(2,0), 0.2],
}


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in map_size.x:
		cells.append([])
		for y in map_size.y:
			cells[i].append(names)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func collapse_cell(cell_coord):
	cells[cell_coord.x[cell_coord.y]]
	tilemap.set_cell(0, cell_coord,0, Vector2(0,0))
	
	#weight the tiles
	#choose one at random
	#update the 
	
