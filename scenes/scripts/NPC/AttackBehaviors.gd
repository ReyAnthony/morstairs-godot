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
var _root: Node2D
var _is_in_fighting_mode := false
var _last_dir := "NW"
var _attack_anim_is_playing := false
var _animated_sprite :AnimatedSprite
var _pathfinder: Navigation2D

func _ready():
	assert($"../" is KinematicBody2D)
	assert($"../FleeNode")
	assert($"../TalkingNPC/Sprite")
	assert($"../TalkingNPC/Sprite" is AnimatedSprite)
	assert($"../Collision")
	assert($"../Collision" is CollisionPolygon2D)
	_root = $"../"
	_animated_sprite = $"../TalkingNPC/Sprite"
	_flee_node = $"../FleeNode"
	$"../TalkingNPC/".connect("is_attacked", self, "_on_NPC_is_attacked")
	$"../TalkingNPC/Interactable".connect("something_is_inside_interactable", self, "_on_Interactable_something_is_inside_interactable")
	$"../TalkingNPC/Sprite".connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")
	_root.add_collision_exception_with($"../TalkingNPC")
	_pathfinder = get_tree().get_nodes_in_group("nav")[0]

var pathfind := []
var _velocity: Vector2 = Vector2(0, 0)
func _process(delta):
	if _target != null and is_instance_valid(_animated_sprite):
		if !is_instance_valid(_target):
			return
		var anim_direction := ""
		var atk := ""
		pathfind = _pathfinder.get_simple_path(_root.global_position, _pathfinder.get_closest_point(_target.global_position), false)
		if(pathfind.size() > 0):
			pathfind.remove(0)
			_velocity = (pathfind[0] - _root.global_position).normalized() 
		
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
			_root.move_and_slide(_velocity.normalized() * 20)

func _on_NPC_is_attacked(attacker: PhysicsBody2D):
	if behavior == Behaviors.FLEE:
		var rnd_dir := Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()
		var rnd_dist :=  rand_range(-10, 10)
		_flee_node.global_position = _root.global_position - rnd_dir * rnd_dist 
		_target = _flee_node
	elif behavior == Behaviors.FIGHT:
		_target = attacker
		_is_in_fighting_mode = true

func _on_Interactable_something_is_inside_interactable(body):
	if body == _target and _is_in_fighting_mode and !_attack_anim_is_playing:
		_attack_anim_is_playing = true

func _on_AnimatedSprite_animation_finished():
	if _animated_sprite.animation.ends_with("MELEE_ATTACK"):
		_attack_anim_is_playing = false
		if $"../TalkingNPC/Interactable/ActionArea".overlaps_body(_target):
			_target.attack(1)