extends Node2D

signal mouse_entered
signal mouse_exited
signal mouse_clicked
signal player_entered_while_interactable_is_targeted(body)

var mouseArea
var actionArea
var is_inside

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
	actionArea.connect("body_exited", self, "_on_ActionArea_body_exited")
	z_index = 255
	
func _on_MouseArea_mouse_entered():
	if !is_inside:
		$Name.show()
		emit_signal("mouse_entered")

func _on_MouseArea_mouse_exited():
	$Name.hide()
	emit_signal("mouse_exited")

func _on_MouseArea_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("mouse_left_click") and !is_inside:
		emit_signal("mouse_clicked")
		
func _on_ActionArea_body_entered(body):
	if body.is_in_group("player"):
		is_inside = true
		_on_MouseArea_mouse_exited()
		emit_signal("player_entered_while_interactable_is_targeted", body)
		
func _on_ActionArea_body_exited(body):
	if body.is_in_group("player"):
		is_inside = false