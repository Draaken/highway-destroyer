extends Node2D
@onready var tilemap: TileMap = $TileMap

@onready var rules_file = FileAccess.open("res://highway/rules.txt", FileAccess.READ)
@onready var rules = rules_file.get_as_text()

var random = RandomNumberGenerator.new()

var map_size = Vector2(20,20)

var cells_waves: Array = []

var is_collapsing = false
var is_generating = true

var names = [
	"right_left",
	"top_down",
	"turn_left_top",
	"turn_right_top",
	"turn_right_bottom",
	"turn_left_bottom",
	"branch_left",
	"branch_right",
	"branch_top",
	"branch_bottom",
	"compost",
	"water",
	"tree",
	]
	
#var tiles_data: Dictionary = {
	##[atlas_coord, alte²rnative_tiles, weight]
	#"right_left": [Vector2(0,0), 1],
	#"top_down": [Vector2(1,0), 1],
	#"turn_left_top": [Vector2(2,0), 0.2],
	#"turn_right_top": [Vector2(3,0), 0.2],
	#"turn_right_bottom": [Vector2(4,0), 0.2],
	#"turn_left_bottom": [Vector2(5,0), 0.2],
	#"branch_left": [Vector2(9,0),0.1],
	#"branch_right": [Vector2(8,0),0.1],
	#"branch_top": [Vector2(7,0),0.1],
	#"branch_bottom": [Vector2(6,0),0.1],
#}
var tiles_data: Dictionary = {
	#[atlas_coord, alternative_tiles, weight]
	"right_left": [Vector2(0,0), 1],
	"top_down": [Vector2(0,0), 1],
	"turn_left_top": [Vector2(0,0), 0.2],
	"turn_right_top": [Vector2(0,0), 0.2],
	"turn_right_bottom": [Vector2(0,0), 0.2],
	"turn_left_bottom": [Vector2(0,0), 0.2],
	"branch_left": [Vector2(0,0),0.1],
	"branch_right": [Vector2(0,0),0.1],
	"branch_top": [Vector2(0,0),0.1],
	"branch_bottom": [Vector2(0,0),0.1],
	"compost": [Vector2(3,0),1000],
	"water": [Vector2(2,0),1500],
	"tree": [Vector2(1,0),500],
}


# Called when the node enters the scene tree for the first time.
func _ready():
	random.randomize()
	
	rules = rules.split("(")
	for i in rules.size()-1:
		rules[i] = rules[i].rsplit(")")[0]
		
	rules.remove_at(0)
	
	for i in map_size.x:
		cells_waves.append([])
		for y in map_size.y:
			cells_waves[i].append(names)
			
	start_highway()
	

func start_highway():
	var random_tile: Vector2 
	match random.randi_range(0,3):
		0: 
			random_tile.x = map_size.x-1
			random_tile.y = random.randi_range(0,map_size.y-1)
		1: 
			random_tile.x = 0
			random_tile.y = random.randi_range(0,map_size.y-1)
		2: 
			random_tile.y = map_size.y-1
			random_tile.x = random.randi_range(0,map_size.x-1)
		3: 
			random_tile.y = 0
			random.randi_range(0,map_size.x-1)
			
	#Vector2(random.randi_range(0,map_size.x),random.randi_range(0,map_size.y))
	cells_waves[random_tile.x][random_tile.y] = [
	"right_left",
	"top_down",
	"branch_left",
	"branch_right",
	"branch_top",
	"branch_bottom",
	]
	set_cell(random_tile, true)
	await get_tree().create_timer(random.randi_range(4,10)).timeout
	start_highway()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_generating:
		if is_collapsing == false:
			var lower_entrophy = 1000
			var lower_enthropy_cells = []
			var is_there_uncollapsed_cell = false
			for x in cells_waves.size():
				for y in cells_waves[x].size():
					if cells_waves[x][y].size() <= lower_entrophy:
						if cells_waves[x][y].size() == 0:
							continue
						is_there_uncollapsed_cell = true
						lower_enthropy_cells.append(Vector2(x,y))
						lower_entrophy = cells_waves[x][y].size()
			#if lower_entrophy == names.size():
				#is_generating = false
				#return
			if not lower_enthropy_cells.is_empty():
				set_cell(lower_enthropy_cells[random.randi_range(0,lower_enthropy_cells.size()-1)])
			if not is_there_uncollapsed_cell: 
				is_generating = false
	
	
func set_cell(cell_coord, is_highway:bool = false):
	if cell_coord.x > map_size.x-1 || cell_coord.x < 0 || cell_coord.y > map_size.y-1 || cell_coord.y < 0:
		return
	if cells_waves[cell_coord.x][cell_coord.y].size() == 0:
		return
	if cells_waves[cell_coord.x][cell_coord.y].is_empty():
		return
	is_collapsing = true
	var available_tiles: Array = cells_waves[cell_coord.x][cell_coord.y]
	
	var choosen_tile: String
	
	var total_weight = 0
	#sum the weight of each available tile
	for i in available_tiles:
		total_weight += tiles_data[i][1]
	var random_number = random.randf_range(0, total_weight)
	
	#stops when it exceeds the random number
	var cursor = 0
	if available_tiles:
		for i in available_tiles:
			cursor += tiles_data[i][1]
			if cursor >= random_number:
				choosen_tile = i
				break
	
	#set the cell to this tile
	if choosen_tile != "":
		tilemap.set_cell(0, cell_coord,3, tiles_data[choosen_tile][0])
		print(cell_coord)
	
	cells_waves[cell_coord.x][cell_coord.y]=[]
	#update the neighbouring cells
	await get_tree().create_timer(1).timeout
	collapse_cell(Vector2(cell_coord.x+1,cell_coord.y), "right", choosen_tile)
	collapse_cell(Vector2(cell_coord.x-1,cell_coord.y), "left", choosen_tile)
	collapse_cell(Vector2(cell_coord.x,cell_coord.y+1), "bottom", choosen_tile)
	collapse_cell(Vector2(cell_coord.x,cell_coord.y-1), "top", choosen_tile)
	
	if is_highway:
		set_cell(Vector2(cell_coord.x+1,cell_coord.y), true)
		set_cell(Vector2(cell_coord.x-1,cell_coord.y), true)
		set_cell(Vector2(cell_coord.x,cell_coord.y+1), true)
		set_cell(Vector2(cell_coord.x,cell_coord.y-1), true)
	
func collapse_cell(cell_coord, direction, old_cell_tile):
	if cell_coord.x > map_size.x-1 || cell_coord.x < 0 || cell_coord.y > map_size.y-1 || cell_coord.y < 0:
		return
	if cells_waves[cell_coord.x][cell_coord.y].size() == 0:
		return
	is_collapsing = true
	cells_waves[cell_coord.x][cell_coord.y]
	var temp_valid_cells = []
	for i in rules:
		var rules_array = i.split(",")
		
		#check the neighbouring cell to see if the rules are valid
		if rules_array[0] != old_cell_tile:
			continue
		if rules_array[2] != direction:
			continue
		temp_valid_cells.append(rules_array[1])
	cells_waves[cell_coord.x][cell_coord.y] = temp_valid_cells
	
	is_collapsing = false
	if temp_valid_cells.size() == 1: 
		set_cell(cell_coord)
		
	
	
	#check if the rule is about the right neigbour and the right direction
	#if yes, add the tile to the new cell options
	#if not ignore it

	
