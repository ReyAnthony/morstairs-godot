extends Sprite

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		print ("entering door")
		$CanEnterArrow.show()

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		print ("exiting door")
		$CanEnterArrow.hide()