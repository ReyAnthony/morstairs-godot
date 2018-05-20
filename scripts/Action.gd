extends Node2D

signal accept_pressed
var player_is_inside = false

func _ready():
	set_process(true)
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept") && player_is_inside:
		player_is_inside = false
		$ActionInfo.hide()
		emit_signal("accept_pressed")
		
func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		player_is_inside = true
		$ActionInfo.show()

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		player_is_inside = false
		$ActionInfo.hide()