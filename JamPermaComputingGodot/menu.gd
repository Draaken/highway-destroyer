extends Node


# Called when the node enters the scene tree for the first time.


func _ready() -> void:
	$Start.visible=true
	$Options.visible=true
	$Number.visible=false
	$Num1.visible=false
	$Num2.visible=false
	$quit.visible=true
	$back.visible=false
	
func _on_start_pressed():
	$Number.visible=true
	$Options.visible=false
	$Start.visible=false
	$Num1.visible=true
	$Num2.visible=true
	$back.visible=true
	$quit.visible=false
	


	

# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_quit_pressed() -> void:
	get_tree().quit() 



func _on_back_pressed() -> void:
	$Start.visible=true
	$Options.visible=true
	$Number.visible=false
	$Num1.visible=false
	$Num2.visible=false
	$quit.visible=true
	$back.visible=false




func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://options.tscn")


func _on_num_1_pressed():
	$"/root/Players".number_of_players = 1
	get_tree().change_scene_to_file("res://main_scence.tscn")


func _on_num_2_pressed():
	$"/root/Players".number_of_players = 2
	get_tree().change_scene_to_file("res://main_scence.tscn")
