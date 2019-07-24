extends Node2D

func _ready():
	assert($Collider != null)

func _on_Collider_body_entered(body):
	if body.is_in_group("player"):
		self.set_modulate(Color(1,1,1, 0.05))
		for t in get_tree().get_nodes_in_group("torchs"):
			if t.inside:
				t.show()

func _on_Collider_body_exited(body):
	if body.is_in_group("player"):
		self.set_modulate(Color(1,1,1, 1))
		for t in get_tree().get_nodes_in_group("torchs"):
			if t.inside:
				t.hide()