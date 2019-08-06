extends GameObjectBase

export (bool) var jail_bed := false
var _is_sleeping := false

func _ready():
	$CanvasLayer.layer = -1
	$CanvasLayer/Panel.hide()
	$CanvasLayer/AnimationPlayer.connect("animation_finished", self, "_on_finished_animation")
	pass

func _on_Interactable_something_is_inside_interactable(body: PhysicsBody2D):
	if body.is_in_group("player") and PlayerDataSingleton.get_target().is_you(self):
		PlayerDataSingleton.clear_target()
		_sleep()
		
func _sleep():
	._on_Interactable_mouse_exited()
	_is_sleeping = true
	$SleepingPC.show()
	PlayerDataSingleton.get_player().hide()
	get_tree().paused = true
	$CanvasLayer.layer = 255
	$CanvasLayer/AnimationPlayer.play("fade")
	PlayerDataSingleton.heal_player()
	
	if PlayerDataSingleton.get_jail_time() > 0 and jail_bed:
		$CanvasLayer/Panel/JailTime.text = "Thee shall still stay " + String(PlayerDataSingleton._jail_time) +" days here."
	else:
		$CanvasLayer/Panel/JailTime.text = ""
		
	if PlayerDataSingleton.get_jail_time() > 0 and jail_bed:
		PlayerDataSingleton.decrement_jail_time()
	if PlayerDataSingleton.get_jail_time() <= 0 and jail_bed:
		PlayerDataSingleton.get_player().global_position = get_tree().get_nodes_in_group("out_jail")[0].global_position

func _on_finished_animation(animation):
	_is_sleeping = false
	$SleepingPC.hide()
	PlayerDataSingleton.get_player().show()
	get_tree().paused = false
	$CanvasLayer.layer = -1