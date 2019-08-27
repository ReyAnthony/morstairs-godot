extends GameObjectBase

export (bool) var jail_bed := false
var _is_sleeping := false

var cursor = preload("res://res/sprites/use.png")
var default_cursor = preload("res://res/sprites/cursor.png")

func _ready():
	$CanvasLayer.layer = -1
	$CanvasLayer/Panel.hide()
	$CanvasLayer/AnimationPlayer.connect("animation_finished", self, "_on_finished_animation")
	pass
	
func _on_Interactable_mouse_entered():
	._on_Interactable_mouse_entered()
	Input.set_custom_mouse_cursor(cursor)
	
func _on_Interactable_mouse_exited():
	._on_Interactable_mouse_exited()
	Input.set_custom_mouse_cursor(default_cursor)

func _on_Interactable_something_is_inside_interactable(body: PhysicsBody2D):
	if body.is_in_group("player") and PDS.get_target().is_you(self):
		PDS.clear_target()
		if PDS.get_bounty() > 0:
			DS.spawn_dialog("", null, $CantUse)
		else:
			if !_is_sleeping:
				_sleep()
		_on_Interactable_mouse_exited()		
		
func _sleep():
	$CanvasLayer.layer = 255
	$CanvasLayer/AnimationPlayer.play("fade")
	
	._on_Interactable_mouse_exited()
	_is_sleeping = true
	$SleepingPC.show()
	PDS.get_player().hide()
	PDS.heal_player()
	
	##TODO you will not get out of jail if you actually wait
	if PDS.get_jail_time() > 0 and jail_bed:
		if PDS.get_jail_time() == 1:
			$CanvasLayer/Panel/JailTime.text = "This is thy last night before freedom."
		else:
			$CanvasLayer/Panel/JailTime.text = "Thou shall still stay " + String(PDS.get_jail_time()) +" night here."
	else:
		$CanvasLayer/Panel/JailTime.text = ""
		
	if PDS.get_jail_time() > 0 and jail_bed:
		PDS.decrement_jail_time()
	if PDS.get_jail_time() <= 0 and jail_bed:
		PDS.get_player().global_position = get_tree().get_nodes_in_group("out_jail")[0].global_position
	PDS.has_slept()
	##get_tree().paused = true #no need to pause as the canvas will block movements

func _on_finished_animation(animation):
	_is_sleeping = false
	$SleepingPC.hide()
	PDS.get_player().show()
	$CanvasLayer.layer = -1
	if jail_bed and PDS.get_jail_time() <= 0:
		DS.spawn_dialog("", null, $AfterJail)