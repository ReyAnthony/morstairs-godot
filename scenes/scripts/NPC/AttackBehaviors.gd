extends Node2D
class_name AttackBehavior

enum Behaviors {
	FLEE,
	FIGHT
	##,FIGHT_THEN_FLEE_ON_LOW_HEALTH
}

export (Behaviors) var behavior

#for the moment we won't use a locomotion component
var _flee_node: Node2D
var _target: Node2D
var _is_in_fighting_mode := false
var _last_dir := "NW"
var _attack_anim_is_playing := false
var _animated_sprite :AnimatedSprite

func _ready():
	assert($"../" is KinematicBody2D)
	assert($"../FleeNode")
	assert($"../TalkingNPC/Sprite")
	assert($"../TalkingNPC/Sprite" is AnimatedSprite)
	assert($"../Collision")
	assert($"../Collision" is CollisionPolygon2D)
	_animated_sprite = $"../TalkingNPC/Sprite"
	_flee_node = $"../FleeNode"
	$"../TalkingNPC/".connect("is_attacked", self, "_on_NPC_is_attacked")
	$"../TalkingNPC/Interactable".connect("something_is_inside_interactable", self, "_on_Interactable_something_is_inside_interactable")
	$"../TalkingNPC/Sprite".connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")
	$"../".add_collision_exception_with($"../TalkingNPC")
	
var _velocity: Vector2 = Vector2(0, 0)
func _process(delta):
	if _target != null and is_instance_valid(_animated_sprite):
		if !is_instance_valid(_target):
			return
		var anim_direction := ""
		var atk := ""
		_velocity = (_target.global_position - self.global_position)
		
		if _velocity.y > 0:
			anim_direction += "S"
		elif _velocity.y < 0:
			anim_direction += "N"
		if _velocity.x < 0:
			anim_direction += "W"
		elif _velocity.x > 0:
			anim_direction += "E"
			
		if anim_direction != "":
			var animation := anim_direction
			if _is_in_fighting_mode: 
				animation += "_FIGHT"
			if _attack_anim_is_playing:
				atk = "_MELEE_ATTACK"
			_animated_sprite.play(animation + atk)
			_last_dir = anim_direction
		if _velocity.length() < 0.1:
			_animated_sprite.stop()
			_animated_sprite.frame = 0
		
		if (_is_in_fighting_mode and !_attack_anim_is_playing) or !_is_in_fighting_mode:
			$"../".move_and_slide(_velocity.normalized() * 20)

func _on_NPC_is_attacked(attacker: PhysicsBody2D):
	if behavior == Behaviors.FLEE:
		_flee_node.global_position = global_position - (attacker.global_position - self.global_position)
		_target = _flee_node
		pass
	elif behavior == Behaviors.FIGHT:
		_target = attacker
		_is_in_fighting_mode = true
		pass
	pass

func _on_Interactable_something_is_inside_interactable(body):
	if body == _target and _is_in_fighting_mode and !_attack_anim_is_playing:
		_attack_anim_is_playing = true		
	pass 

func _on_AnimatedSprite_animation_finished():
	if _animated_sprite.animation.ends_with("MELEE_ATTACK"):
		_attack_anim_is_playing = false
		if $"../TalkingNPC/Interactable/ActionArea".overlaps_body(_target):
			_target.attack(1)