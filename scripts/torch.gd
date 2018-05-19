extends Sprite

var light_it = true

func light_it():
	light_it = true
	$AnimationPlayer.stop(true)
	$Light2D.energy = 0
	$AnimationPlayer.play("light_on")
	$Light2D.show()
	
func unlight_it():
	light_it = false
	$AnimationPlayer.stop(true)
	$AnimationPlayer.play_backwards("light_on")

func _on_AnimationPlayer_animation_finished(anim_name):	
	if anim_name == "light_on" && light_it:
		$AnimationPlayer.play("torch_anim")
	if anim_name == "light_on" && !light_it:
		$Light2D.hide()	
