extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("right1"):
		position.x += 50
	if Input.is_action_just_pressed("left1"):
		position.x -= 50
	if Input.is_action_just_pressed("top1"):
		position.y -= 50
	if Input.is_action_just_pressed("bottom1"):
		position.y += 50
	if Input.is_action_just_pressed("action"):
		var map_pos = $"../TileMap".local_to_map(position)
		$"..".cells_waves[map_pos.x][map_pos.y] = ["water"]
		$"..".set_cell(map_pos)
