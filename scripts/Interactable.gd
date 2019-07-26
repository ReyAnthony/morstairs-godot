extends Node2D

signal mouse_entered
signal mouse_exited
signal mouse_clicked
signal something_entered_inside_interactable(body)
export (String) var group_to_test_on_enter 

var mouseArea
var actionArea
var far_end_of_the_world = Vector2(-9999999, 99999999)
var old_pos
var hack = false
var clicked = false

func _ready():
	assert($MouseArea != null)
	assert($ActionArea != null)
	assert($Name != null)
	mouseArea = $MouseArea
	actionArea = $ActionArea
	mouseArea.connect("input_event", self, "_on_MouseArea_input_event")
	mouseArea.connect("mouse_entered", self, "_on_MouseArea_mouse_entered")
	mouseArea.connect("mouse_exited", self, "_on_MouseArea_mouse_exited")
	actionArea.connect("body_entered", self, "_on_ActionArea_body_entered")
	z_index = 255
	
func _process(delta):
	if hack:
		$ActionArea.global_position = old_pos
		hack = false

func _on_MouseArea_mouse_entered():
	$Name.show()
	emit_signal("mouse_entered")
	clicked = false

func _on_MouseArea_mouse_exited():
	$Name.hide()
	emit_signal("mouse_exited")

func _on_MouseArea_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("mouse_left_click") and !clicked:
		emit_signal("mouse_clicked")
		clicked = true
		if !hack:
			old_pos = $ActionArea.global_position 
			$ActionArea.global_position = far_end_of_the_world
			hack = true
		
func _on_ActionArea_body_entered(body):	
	if body.is_in_group(group_to_test_on_enter):
		emit_signal("something_entered_inside_interactable", body)
		_on_MouseArea_mouse_exited()