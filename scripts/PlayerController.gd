extends KinematicBody2D

export (Material) var material_on_mouse_entered: Material

const _WALK_SPEED := 30
const _PDS: PDS = PlayerDataSingleton
var _velocity := Vector2()
var _is_attacking := false
var _last_dir := "NW"

func _ready():
	set_process(true)
	$AnimatedSprite.play("NW")
	add_to_group("player")
	
# warning-ignore:unused_argument
func _process(delta: float):
	var anim_direction := ""
	var anim := ""
	var target: PlayerTarget = _PDS.get_target()
		
	if Input.is_action_just_pressed("switch_combat_mode"):
		_PDS.clear_target()
		if _PDS.fight_mode: 
			$AnimationPlayer.play("FightOff")
			$AnimatedSprite.play(_last_dir)
		else:
			$AnimationPlayer.play("FightOn")
			$AnimatedSprite.play(_last_dir + "_FIGHT")
		_PDS.fight_mode = !_PDS.fight_mode
	
	if  target != null:
		#make movement only diagonal, so we don't have to make 8 sprites
		_velocity = (target.position - self.global_position).normalized()
		
		if _velocity.y > 0:
			anim_direction += "S"
		elif _velocity.y < 0:
			anim_direction += "N"
		if _velocity.x < 0:
			anim_direction += "W"
		elif _velocity.x > 0:
			anim_direction += "E"
		
		if (target.position - self.global_position).length() < 2:
			_PDS.clear_target()
			_velocity.x = 0
			_velocity.y = 0
		pass
		
		if target.node != null and is_instance_valid(target.node) and target.node.is_in_group("npc"):
			if !$Interactable/ActionArea.overlaps_body(target.node):
				_is_attacking = false
	else:
		_is_attacking = false	

	if _PDS.fight_mode:
		anim = "_FIGHT"	
		if _is_attacking and _PDS.get_target() != null:
			anim += "_MELEE_ATTACK"	

	if anim_direction != "":
		$AnimatedSprite.play(anim_direction + anim)
		_last_dir = anim_direction
	if _velocity.length() < 0.1:
		$AnimatedSprite.stop()
		$AnimatedSprite.frame = 0
		
	move_and_slide(_velocity.normalized() * _WALK_SPEED)

func _on_AnimatedSprite_animation_finished():
	var target: PlayerTarget = _PDS.get_target()
	if target == null or !is_instance_valid(target.node):
		_is_attacking = false
		return
	if _is_attacking \
		and target != null \
		and target.node != null \
		and (target.node as NPC).can_be_hit \
		and $AnimatedSprite.animation.ends_with("MELEE_ATTACK")\
		and $Interactable/ActionArea.overlaps_body(target.node):
			target.node.attack(1)
			
# warning-ignore:unused_argument
func _unhandled_input(event: InputEvent):
	if Input.is_action_pressed("mouse_left_click"):
		_is_attacking = false	
		_PDS.set_target(get_global_mouse_position(), null)
	else:
		_velocity.x = 0
		_velocity.y = 0

func _on_Interactable_something_entered_inside_interactable(body: PhysicsBody2D):
	var target: PlayerTarget = _PDS.get_target()	
	if target == null or !_PDS.fight_mode:
		return
	if target.node == body and !(target.node as NPC).can_be_hit:
		_is_attacking = false
		_PDS.clear_target()
	elif target.node == body:
		_is_attacking = true

func _on_Interactable_mouse_clicked():
	if !_PDS.fight_mode:
		_PDS.clear_target()
		get_tree().paused = true
		$CanvasLayer/PlayerInventory.show_inventory()

func _on_Interactable_mouse_entered():
	$AnimatedSprite.material = material_on_mouse_entered

func _on_Interactable_mouse_exited():
	$AnimatedSprite.material = null
