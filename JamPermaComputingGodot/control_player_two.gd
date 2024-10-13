extends Control

var can_change_key = false
var action_string
enum ACTIONS {left2,right2,Up2,Down2,Slash2}
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
func b_change_key_left2():
	_mark_button("left2")

func b_change_key_right2():
	_mark_button("right2")

func b_change_key_Up2():
	_mark_button("Up2")
	
func b_change_key_Down2():
	_mark_button("Down2")

func b_change_key_Slash2():
	_mark_button("Slash2")
	
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


func _on_but_left_2_pressed() -> void:
	b_change_key_left2()

func _on_but_up_2_pressed() -> void:
	b_change_key_Up2()

func _on_but_down_2_pressed() -> void:
	b_change_key_Down2()


func _on_but_right_2_pressed() -> void:
	b_change_key_right2()

func _on_but_slash_2_pressed() -> void:
	b_change_key_Slash2()
