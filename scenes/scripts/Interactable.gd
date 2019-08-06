extends Node2D
class_name Interactable

signal mouse_entered
signal mouse_exited
signal mouse_clicked
signal something_is_inside_interactable(body)

export (String) var group_to_test_on_enter: String

var _mouseArea: Area2D
var _actionArea: Area2D
var _is_mouse_inside := false
var _is_body_inside := false

func _ready():
	assert($MouseArea != null)
	assert($ActionArea != null)
	assert($Name != null)
	assert(group_to_test_on_enter != "")
	_mouseArea = $MouseArea
	_actionArea = $ActionArea
	_mouseArea.connect("mouse_entered", self, "_on__mouseArea_mouse_entered")
	_mouseArea.connect("mouse_exited", self, "_on__mouseArea_mouse_exited")
	$Timer.connect("timeout", self, "_on_timer_timeout_hide_name")
	z_index = 255

func _process(delta: float):
	for b in _actionArea.get_overlapping_bodies():
		if (b.is_in_group(group_to_test_on_enter)):
			emit_signal("something_is_inside_interactable", b)
			_is_body_inside = true
			return
	_is_body_inside = false
	
func _input(event: InputEvent):
	if get_tree().paused:
		return
	if Input.is_action_just_pressed("mouse_left_click") and _is_mouse_inside:
		emit_signal("mouse_clicked")
		get_tree().set_input_as_handled()
		
	if Input.is_action_just_pressed("mouse_right_click") and _is_mouse_inside:
		show_name()
		get_tree().set_input_as_handled()
			
	if Input.is_action_pressed("mouse_left_click") and _is_mouse_inside and _is_body_inside:
		get_tree().set_input_as_handled()
	
func _on__mouseArea_mouse_entered():
	_is_mouse_inside = true
	emit_signal("mouse_entered")

func _on__mouseArea_mouse_exited():
	_is_mouse_inside = false
	emit_signal("mouse_exited")
	
func show_name():
	$Name.show()
	$Timer.start(1)
	
func _on_timer_timeout_hide_name():
	$Name.hide()
	$Timer.stop()	