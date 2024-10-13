extends Node2D
var random = RandomNumberGenerator.new()

@onready var map_size = $"..".map_size
var pilots = []
var craks = preload("res://crack.tscn")

#0 left, 1 top, 2 right, 3 bottom

# Called when the node enters the scene tree for the first time.
func _ready():
	random.randomize()
	extend_road()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func create_pilot():
	var random_tile: Vector2 
	var direction
	match random.randi_range(0,3):
		0: 
			random_tile.x = map_size.x -1
			random_tile.y = random.randi_range(0,map_size.y -1)
			direction = 0
		1: 
			random_tile.x = 0
			random_tile.y = random.randi_range(0,map_size.y -1)
			direction = 2
		2: 
			random_tile.y = map_size.y -1
			random_tile.x = random.randi_range(0,map_size.x -1)
			direction = 1
		3: 
			random_tile.y = 0
			random.randi_range(0,map_size.x -1)
			direction = 3
	pilots.append([random_tile,direction,9])
	$"..".cells_waves[random_tile.x][random_tile.y] = ["road"]
	$"..".set_cell(random_tile, true)
	if get_tree():
		var timer = Timer.new()
		timer.wait_time = (random.randi_range(4,10))
		add_child(timer)
		timer.start()
		await timer.timeout
	create_pilot()
		

func extend_road():
	var cracks_list = []
	if pilots.is_empty():
		var timer = Timer.new()
		timer.wait_time = 1
		add_child(timer)
		timer.start()
		await timer.timeout
		extend_road()
		return
	
		
	for current_pilot in pilots:
		if current_pilot[2] <=0: 
			continue
		if current_pilot[0].x >= map_size.x ||current_pilot[0].x < 0:
			continue
		if current_pilot[0].y >= map_size.y ||current_pilot[0].y < 0:
			continue
		if $"..".cells_durability[current_pilot[0].x][current_pilot[0].y] >0:
			$"..".cells_durability[current_pilot[0].x][current_pilot[0].y] -= 1
			current_pilot[2] -= 1
			var instance = craks.instantiate()
			add_child(instance)
			instance.position = $"../TileMap".map_to_local(current_pilot[0])
			instance.frame = 2 - $"..".cells_durability[current_pilot[0].x][current_pilot[0].y]
			current_pilot[0]
			cracks_list.append(instance)

			continue
		#print($"..".cells_durability)
		
		if current_pilot[0].x >= map_size.x ||current_pilot[0].x < 0:
			continue
		if current_pilot[0].y >= map_size.y ||current_pilot[0].y < 0:
			continue
		if $"..".cells_durability[current_pilot[0].x][current_pilot[0].y] >0:
			continue
		#$"..".cells_waves[current_pilot[0].x][current_pilot[0].y] = [
			#"right_left",
			#"top_down",
			#"branch_left",
			#"branch_right",
			#"branch_top",
			#"branch_bottom",
		#]
		$"..".cells_waves[current_pilot[0].x][current_pilot[0].y] = ["road"]
		$"..".set_cell(current_pilot[0], true)
		
		var random_factor = random.randi_range(0,30)
		if random_factor>28:
			current_pilot[1]+= 1
		if random_factor < 2: 
			current_pilot[1]-= 1
		if current_pilot[1]<0:
			current_pilot[1] = 3
		elif current_pilot[1] > 3:
			current_pilot[1] = 0
		if random.randi_range(0,80) <4:
			if random.randi_range(0,1)==0:
				pilots.append([current_pilot[0], current_pilot[1]+1,current_pilot[2]%2])
			else:
				pilots.append([current_pilot[0], current_pilot[1]-1,current_pilot[2]%2])
		match current_pilot[1]:
			0: current_pilot[0] += Vector2(-1,0)
			1: current_pilot[0] += Vector2(0,-1)
			2: current_pilot[0] += Vector2(1,0)
			3: current_pilot[0] += Vector2(0,1)
		print("road_extended" + str(current_pilot))
	var timer = Timer.new()
	timer.wait_time = 1
	add_child(timer)
	timer.start()
	await timer.timeout
	for i in range(cracks_list.size()-1, -1, -1):
		cracks_list[i].queue_free()
	extend_road()
