extends Node2D
@export var player_number: int
var available_tiles = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = str(available_tiles)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("right"+str(player_number)):
		if position.x < 650:
			position.x += 50
	if Input.is_action_just_pressed("left"+str(player_number)):
		if position.x > 0:
			position.x -= 50
	if Input.is_action_just_pressed("top"+str(player_number)):
		if position.y > 0:
			position.y -= 50
	if Input.is_action_just_pressed("bottom"+str(player_number)):
		if position.y < 650:
			position.y += 50
	if Input.is_action_just_pressed("action"+str(player_number)):
		if available_tiles > 0:
			$"..".is_paused = false
			var map_pos = $"../TileMap".local_to_map(position)
			$"..".cells_waves[map_pos.x][map_pos.y] = ["water"]
			$"..".set_cell(map_pos)
			available_tiles -= 1
			$Label.text = str(available_tiles)
			#if $"..".available_tiles == 0:
				#$"..".is_paused = false
				#await get_tree().create_timer(3).timeout
				#$"..".start_highway()
	#position = $"../TileMap".local_to_map(get_global_mouse_position())*50
