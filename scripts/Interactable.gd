extends Node2D

signal mouse_entered
signal mouse_exited
signal mouse_clicked
signal something_entered_inside_interactable(body)
export (String) var group_to_test_on_enter 
export (NodePath) var body_to_move 

var mouseArea
var actionArea
var is_mouse_inside = false

func _ready():
	assert($MouseArea != null)
	assert($ActionArea != null)
	assert($Name != null)
	assert(group_to_test_on_enter != "")
	assert(body_to_move != "")
	mouseArea = $MouseArea
	actionArea = $ActionArea
	mouseArea.connect("mouse_entered", self, "_on_MouseArea_mouse_entered")
	mouseArea.connect("mouse_exited", self, "_on_MouseArea_mouse_exited")
	z_index = 255
	body_to_move = get_node(body_to_move)

func _process(delta):
	for b in $ActionArea.get_overlapping_bodies():
		if (b.is_in_group(group_to_test_on_enter)):
			emit_signal("something_entered_inside_interactable", b)
			return
	
func _input(event):
	if get_tree().paused:
		return
		
	if Input.is_action_just_pressed("mouse_left_click") and is_mouse_inside:
		emit_signal("mouse_clicked")
		get_tree().set_input_as_handled() 
	if Input.is_action_pressed("mouse_left_click") and is_mouse_inside:
		get_tree().set_input_as_handled() 
	
func _on_MouseArea_mouse_entered():
	$Name.show()
	is_mouse_inside = true
	emit_signal("mouse_entered")

func _on_MouseArea_mouse_exited():
	$Name.hide()
	is_mouse_inside = false
	emit_signal("mouse_exited")