extends Node2D
class_name Room

func _ready():
	var has_collider: bool
	for c in get_children():
		if c is Area2D:
			c.connect("body_entered", self, "_on_Collider_body_entered")
			c.connect("body_exited", self, "_on_Collider_body_exited")
			has_collider = true
	if !has_collider:
		assert(false)		

func _on_Collider_body_entered(body: PhysicsBody2D):
	if body == null:
		return
	if body.is_in_group("player"):
		$AnimationPlayer.play("enter_inside")
		for t in get_tree().get_nodes_in_group("torchs"):
			var tt: Torch = t as Torch
			if tt.inside:
				tt.show()

func _on_Collider_body_exited(body: PhysicsBody2D):
	if body == null:
		return
	if body.is_in_group("player"):
		$AnimationPlayer.play("go_outside")
		for t in get_tree().get_nodes_in_group("torchs"):
			var tt: Torch = t as Torch
			if tt.inside:
				tt.hide()