extends KinematicBody2D
class_name Player

export (Material) var material_on_mouse_entered: Material

const _WALK_SPEED := 30
const _PDS: PDS = PlayerDataSingleton
var _velocity := Vector2()
var _is_attacking := false
var _last_dir := "NW"

func attack(amount: int):
	$Stats.attack(amount)

func _ready():
	set_process(true)
	$AnimatedSprite.play("NW")
	add_to_group("player")
	$Interactable.connect("mouse_clicked", self, "_on_player_mouse_clicked")
	$Interactable.connect("mouse_entered", self,  "_on_player_mouse_entered")
	$Interactable.connect("mouse_exited", self, "_on_player_mouse_exited")
	$Interactable.connect("something_is_inside_interactable", self, "_on_player_npc_is_inside_action_zone")
	$AnimatedSprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")
	$CanvasLayer/TextureButton.connect("pressed", self, "_on_combat_mode_switch")
	
# warning-ignore:unused_argument
func _process(delta: float):
	var anim_direction := ""
	var anim := ""
	var target: PlayerTarget = _PDS.get_target()
		
	if Input.is_action_just_pressed("switch_combat_mode"):
		_on_combat_mode_switch()
	
	if  target.is_valid():
		#make movement only diagonal, so we don't have to make 8 sprites
		_velocity = (target.get_position() - self.global_position).normalized()
		
		if _velocity.y > 0:
			anim_direction += "S"
		elif _velocity.y < 0:
			anim_direction += "N"
		if _velocity.x < 0:
			anim_direction += "W"
		elif _velocity.x > 0:
			anim_direction += "E"
		
		if (target.get_position() - self.global_position).length() < 2:
			_PDS.clear_target()
			_velocity.x = 0
			_velocity.y = 0
		pass
		
		if target.is_valid() and target.targetType == target.TargetType.ACTION_TARGET and target.node.is_in_group("npc"):
			if !$Interactable/ActionArea.overlaps_body(target.node):
				_is_attacking = false
	else:
		_is_attacking = false
		_velocity.x = 0
		_velocity.y = 0

	if _PDS.fight_mode:
		anim = "_FIGHT"	
		if _is_attacking and _PDS.get_target().is_valid():
			anim += "_MELEE_ATTACK"	

	if anim_direction != "":
		$AnimatedSprite.play(anim_direction + anim)
		_last_dir = anim_direction
	if _velocity.length() < 0.1:
		$AnimatedSprite.stop()
		$AnimatedSprite.frame = 0
	
	if !_is_attacking:	
		move_and_slide(_velocity.normalized() * _WALK_SPEED)

func _on_AnimatedSprite_animation_finished():
	var target: PlayerTarget = _PDS.get_target()
	if !target.is_valid() or target.targetType != target.TargetType.ACTION_TARGET:
		_is_attacking = false
		return
	if _is_attacking \
		and target.is_valid() \
		and target.targetType == target.TargetType.ACTION_TARGET \
		and target.node.can_be_hit \
		and $AnimatedSprite.animation.ends_with("MELEE_ATTACK")\
		and $Interactable/ActionArea.overlaps_body(target.node):
			target.node.attack(1, self)
			
# warning-ignore:unused_argument
func _unhandled_input(event: InputEvent):
	##TODO small bug after dialogs, player will move where clicked, but not everytime
	if Input.is_action_pressed("mouse_left_click"):
		_is_attacking = false	
		_PDS.set_target(get_global_mouse_position())
	else:
		_velocity.x = 0
		_velocity.y = 0
		
func _on_player_npc_is_inside_action_zone(body: PhysicsBody2D):
	var target: PlayerTarget = _PDS.get_target()	
	if !target.is_valid() or !_PDS.fight_mode or target.targetType != target.TargetType.ACTION_TARGET:
		return
	if target.node == body and !target.node.can_be_hit:
		_is_attacking = false
		_PDS.clear_target()
	elif target.node == body:
		_is_attacking = true

func _on_combat_mode_switch():
	_PDS.clear_target()
	if _PDS.fight_mode: 
		$AnimatedSprite.play(_last_dir)
		_unclear_player_selection()
	else:
		$AnimatedSprite.play(_last_dir + "_FIGHT")
		_clear_player_selection(true)
	_PDS.fight_mode = !_PDS.fight_mode

func _on_player_mouse_clicked():
	if !_PDS.fight_mode:
		_PDS.clear_target()
		get_tree().paused = true
		$CanvasLayer/PlayerInventory.show_inventory()
		_clear_player_selection()

func _on_player_mouse_entered():
	if !_PDS.fight_mode:
		$AnimatedSprite.material = material_on_mouse_entered

func _on_player_mouse_exited():
	$AnimatedSprite.material = null
	
func _clear_player_selection(forever: bool = false):
	$AnimatedSprite.material = null
	if forever:
		$Interactable.show_name = false
	$Interactable.hide_name()
	
func _unclear_player_selection():
	$Interactable.show_name = true
