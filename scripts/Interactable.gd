extends Node2D

signal mouse_entered
signal mouse_exited
signal mouse_clicked
signal player_entered_while_interactable_is_targeted(body)

var mouseArea
var actionArea

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
	
func _on_MouseArea_mouse_entered():
	$Name.show()
	emit_signal("mouse_entered")

func _on_MouseArea_mouse_exited():
	$Name.hide()
	emit_signal("mouse_exited")

func _on_MouseArea_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("mouse_left_click"):
		emit_signal("mouse_clicked")
		
func _on_ActionArea_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("player_entered_while_interactable_is_targeted", body)