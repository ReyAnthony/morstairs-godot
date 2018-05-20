extends Sprite

func light_it():
	$AnimationPlayer.stop(true)
	$Light2D.energy = 0
	$AnimationPlayer.play("light_on")
	$Light2D.show()
	
func unlight_it():
	$AnimationPlayer.stop(true)
	$AnimationPlayer.play("light_off")

func _on_AnimationPlayer_animation_finished(anim_name):	
	if anim_name == "light_on":
		$AnimationPlayer.play("torch_anim")
	if anim_name == "light_off":
		$Light2D.hide()	
