extends Control

var can_change_key = false
var action_string
enum ACTIONS {left1,right1,Up1,Down1,Slash1}
# Called when the node enters the scene tree for the first time.
func _ready():
	_set_keys()  
  
func _set_keys():
	for j in ACTIONS:
		get_node("but_" + str(j)).set_pressed(false)
		if !InputMap.action_get_events(j).is_empty():
			get_node("but_" + str(j)).set_text(InputMap.action_get_events(j)[0].as_text())
		else:
			get_node("but_" + str(j)).set_text("No Button!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func b_change_key_left1():
	_mark_button("left1")

func b_change_key_right1():
	_mark_button("right1")

func b_change_key_Up1():
	_mark_button("top1")
	
func b_change_key_Down1():
	_mark_button("bottom1")

func b_change_key_Slash1():
	_mark_button("action1")
	
func _mark_button(string):
	can_change_key = true
	action_string = string
	
	for j in ACTIONS:
		if j != string:
			get_node("but_" + str(j)).set_pressed(false)

#Change Keys
func _input(event):
	if event is InputEventKey: 
		if can_change_key:
			_change_key(event)
			can_change_key = false
			
func _change_key(new_key):
	#Delete key of pressed button
	if !InputMap.action_get_events(action_string).is_empty():
		InputMap.action_erase_event(action_string, InputMap.action_get_events(action_string)[0])
	
	#Check if new key was assigned somewhere
	for i in ACTIONS:
		if InputMap.action_has_event(i, new_key):
			InputMap.action_erase_event(i, new_key)
			
	#Add new Key
	InputMap.action_add_event(action_string, new_key)
	
	
	_set_keys()




func _on_but_up_pressed() -> void:
	b_change_key_Up1()


func _on_but_right_1_pressed() -> void:
	b_change_key_right1()




func _on_but_left_1_pressed() -> void:
	b_change_key_left1()


func _on_but_slash_pressed() -> void:
	b_change_key_Slash1()

func _on_but_down_pressed() -> void:
	b_change_key_Down1()
