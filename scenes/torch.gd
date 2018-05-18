extends Sprite

func light_it():
	$AnimationPlayer.stop(true)
	#$AnimationPlayer.play("torch_anim")
	$AnimationPlayer.play("light_on")
	$Light2D.show()
	
func unlight_it():
	$AnimationPlayer.stop(true)
	$Light2D.hide()