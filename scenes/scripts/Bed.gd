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
		if PlayerDataSingleton.get_bounty() > 0:
			$CanvasLayer/DialogPanel.my_popup("", null, $CantUse)
		else:	
			_sleep()
		
func _sleep():
	._on_Interactable_mouse_exited()
	_is_sleeping = true
	$SleepingPC.show()
	PlayerDataSingleton.get_player().hide()
	$CanvasLayer.layer = 255
	$CanvasLayer/AnimationPlayer.play("fade")
	PlayerDataSingleton.heal_player()
	
	if PlayerDataSingleton.get_jail_time() > 0 and jail_bed:
		if PlayerDataSingleton.get_jail_time() == 1:
			$CanvasLayer/Panel/JailTime.text = "This is your last night before freedom."
		else:
			$CanvasLayer/Panel/JailTime.text = "Thee shall still stay " + String(PlayerDataSingleton._jail_time) +" night here."
	else:
		$CanvasLayer/Panel/JailTime.text = ""
		
	if PlayerDataSingleton.get_jail_time() > 0 and jail_bed:
		PlayerDataSingleton.decrement_jail_time()
	if PlayerDataSingleton.get_jail_time() <= 0 and jail_bed:
		PlayerDataSingleton.get_player().global_position = get_tree().get_nodes_in_group("out_jail")[0].global_position
	PlayerDataSingleton.has_slept()
	##get_tree().paused = true #no need to pause as the canvas will block movements

func _on_finished_animation(animation):
	_is_sleeping = false
	$SleepingPC.hide()
	PlayerDataSingleton.get_player().show()
	$CanvasLayer.layer = -1
	if jail_bed and PlayerDataSingleton.get_jail_time() <= 0:
		$CanvasLayer/DialogPanel.my_popup("", null, $AfterJail)