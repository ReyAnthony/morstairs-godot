extends KinematicBody2D
class_name Player

export (NodePath) var map_cam: NodePath
const ObjectType = preload("res://scenes/scripts/Objects/ObjectType.gd").ObjectType
const SubType = preload("res://scenes/scripts/Objects/ObjectType.gd").SubType

const _WALK_SPEED := 30
var _velocity := Vector2()
var _last_dir := "NW"
var _is_attacking := false
var _sprite: AnimatedSprite

func _ready():
	_sprite = $AnimatedSprite
	_sprite.play("NW")
	add_to_group("player")
	$Interactable.connect("something_is_inside_interactable", self, "_on_player_npc_is_inside_action_zone")
	_sprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")
	PDS.connect("combat_mode_change", self, "_on_combat_mode_change")
	$Interactable/Name.text = PDS.get_player_name()

func attack(attackerDoll: Doll, attacker: PhysicsBody2D):
	var dmg = attackerDoll.get_damages(get_doll())
	get_stats().attack(dmg)
	
func full_heal():
	get_stats().full_heal()
	
func get_stats():
	return PDS.get_stats()
	
func get_doll():
	return PDS.get_chara_doll()

# warning-ignore:unused_argument
func _process(delta: float):	
	var anim_direction := ""
	var anim := ""
	var target: PlayerTarget = PDS.get_target()
		
	if  target.is_valid():
		if PDS.get_chara_doll().get_weapon_subtype() == SubType.MELEE or target.targetType != target.TargetType.ACTION_TARGET or !target.node.can_be_hit or !PDS.is_fighting():
			_velocity = (target.get_position() - self.global_position).normalized()
			anim_direction += _determine_sprite_direction()
			if target.get_position().distance_to(self.global_position) < 2:
				PDS.clear_target()
				_velocity = Vector2.ZERO
		elif PDS.get_chara_doll().get_weapon_subtype() == SubType.RANGED:
			_velocity = (target.get_position() - self.global_position).normalized()
			anim_direction += _determine_sprite_direction()
			_velocity = Vector2.ZERO
			_is_attacking = true
			if target.get_position().distance_to(self.global_position) > 2000: ##completely arbitrary
				PDS.clear_target() 
				_velocity = Vector2.ZERO
		else:
			assert(false)
	else:
		_is_attacking = false
		_velocity = Vector2.ZERO

	if PDS.is_fighting():
		if PDS.get_chara_doll().get_weapon_subtype() == SubType.MELEE:
			anim = "_MELEE"
		else:
			anim = "_RANGED"
		if _is_attacking and PDS.get_target().is_valid():
			anim += "_ATK"

	if anim_direction != "":
		_sprite.play(anim_direction + anim)
		_last_dir = anim_direction
	else:
		_sprite.stop()
		_sprite.play(_last_dir + anim)
		_sprite.frame = 0
	
	if !_is_attacking:
		move_and_slide(_velocity.normalized() * _WALK_SPEED)
		var has_collided_with_target = false
		for i in get_slide_count():
			var collision: KinematicCollision2D = get_slide_collision(i)
			if !(collision.collider.is_in_group("npc") and PDS.is_fighting()):
				PDS.clear_target()
				_velocity = Vector2.ZERO

func _determine_sprite_direction():
	var dir = ""
	if _velocity.y > 0:
		dir += "S"
	elif _velocity.y < 0:
		dir += "N"
	if _velocity.x < 0:
		dir += "W"
	elif _velocity.x > 0:
		dir += "E"
	return dir

func _on_AnimatedSprite_animation_finished():
	var target: PlayerTarget = PDS.get_target()
	if !target.is_valid() or target.targetType != target.TargetType.ACTION_TARGET:
		_is_attacking = false
		return
			
	if _is_attacking \
		and target.is_valid() \
		and target.targetType == target.TargetType.ACTION_TARGET \
		and target.node.can_be_hit:
			if _sprite.animation.ends_with("MELEE_ATK")\
				and PDS.get_chara_doll().get_weapon_subtype() == SubType.MELEE\
				and $Interactable/ActionArea.overlaps_body(target.node):
					target.node.attack(PDS.get_chara_doll(), self)
			elif _sprite.animation.ends_with("RANGED_ATK")\
				and PDS.get_chara_doll().get_weapon_subtype() == SubType.RANGED:
					var foe_dir = (target.get_position() - self.global_position).normalized()
					PDS.get_chara_doll().use_ranged_weapon(foe_dir, global_position, self)
	_is_attacking = false
			
# warning-ignore:unused_argument
func _unhandled_input(event: InputEvent):
	if Input.is_action_pressed("mouse_left_click"):
		_is_attacking = false
		PDS.set_target(get_global_mouse_position())
	else:
		_velocity = Vector2.ZERO

func _on_combat_mode_change(mode: bool):
	if !mode: 
		_sprite.play(_last_dir)
	else:
		if PDS.get_chara_doll().get_weapon_subtype() == SubType.MELEE:
			_sprite.play(_last_dir + "_MELEE")
		else:
			_sprite.play(_last_dir + "_RANGED")

func _on_player_npc_is_inside_action_zone(body: PhysicsBody2D):
	var target: PlayerTarget = PDS.get_target()	
	if !target.is_valid() or !PDS.is_fighting() or target.targetType != target.TargetType.ACTION_TARGET:
		return
	if target.node == body and !target.node.can_be_hit:
		_is_attacking = false
		PDS.clear_target()
	elif target.node == body:
		_is_attacking = true
