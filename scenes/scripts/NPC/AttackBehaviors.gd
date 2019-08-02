extends Node2D
class_name AttackBehavior

enum Behaviors {
	FLEE,
	FIGHT
}

export (Behaviors) var behavior

#for the moment we won't use a locomotion component
var _initial_position: Vector2
var _go_back_to_initial_position := false
var _initial_dir := ""
var _target: Node2D
var _root: Node2D
var _last_dir := "SE"
var _attack_anim_is_playing := false
var _animated_sprite :AnimatedSprite
var _pathfinder: Navigation2D
var _free_target: Node2D
var _viewArea: Area2D
var pathfind := []
var _velocity: Vector2 = Vector2(0, 0)

#debug
var _debug := true
var _line : Line2D

#TODO when bounty, GUARD attack on sight
"""
if (player is colliding guard zone) and bounty[morstairs] > 0:
	_target = player
	_go_back_to_initial_position = false #just in case
"""

func _ready():
	assert($"../" is KinematicBody2D)
	assert($"../TalkingNPC/Sprite")
	assert($"../TalkingNPC/Sprite" is AnimatedSprite)
	assert($"../Collision")
	assert($"../Collision" is CollisionPolygon2D)
	assert($ViewArea != null)
	_root = $"../"
	_animated_sprite = $"../TalkingNPC/Sprite"
	_free_target = Node2D.new()
	get_tree().root.add_child(_free_target)

	_pathfinder = get_tree().get_nodes_in_group("nav")[0]
	_initial_position = _root.global_position
	_initial_dir = _last_dir
	_line = $"/root/Level/Line2D" as Line2D
	_viewArea = $ViewArea
	
	$"../TalkingNPC/".connect("is_attacked", self, "_on_NPC_is_attacked")
	$"../TalkingNPC/Interactable".connect("something_is_inside_interactable", self, "_on_Interactable_something_is_inside_interactable")
	_animated_sprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")
	_root.add_collision_exception_with($"../TalkingNPC")
	z_index = 255
	
func _process(delta):
	if _target != null and is_instance_valid(_animated_sprite):
		if !is_instance_valid(_target):
			return
			
		var anim_direction := ""
		var atk := ""
		
		pathfind = _pathfinder.get_simple_path(_root.global_position, _target.global_position, false)
		if(pathfind.size() > 0):
			if _debug:
				_line.clear_points()
				for n in pathfind:
					_line.add_point(n)
			pathfind.remove(0)
			_velocity = (pathfind[0] - _root.global_position).normalized()
		else:
			assert(false)
				
		if _go_back_to_initial_position:
			if _root.global_position.distance_to(_initial_position) <= 5:
				_go_back_to_initial_position = false
				_target = null
				_animated_sprite.play(_initial_dir)
				_animated_sprite.stop()
				_animated_sprite.frame = 0
				return
		elif behavior == Behaviors.FIGHT:
			if(_root.global_position.distance_to(_target.global_position) > 150):
				_go_back_to_initial_position = true
				_free_target.global_position = _initial_position
				_target = _free_target
		elif behavior == Behaviors.FLEE:
			if _root.global_position.distance_to(_target.global_position) <= 5:
				_target = null
				
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
			if behavior == Behaviors.FIGHT: 
				animation += "_FIGHT"
			if _attack_anim_is_playing:
				atk = "_MELEE_ATTACK"
			_animated_sprite.play(animation + atk)
			_last_dir = anim_direction
		if _velocity.length() < 0.1:
			_animated_sprite.stop()
			_animated_sprite.frame = 0
		
		if (behavior == Behaviors.FIGHT and !_attack_anim_is_playing) or behavior != Behaviors.FIGHT:
			_root.move_and_slide(_velocity.normalized() * 20)
	else:
		_animated_sprite.stop()
		_animated_sprite.frame = 0
		var body = get_tree().get_nodes_in_group("player")[0]
		if $ViewArea.overlaps_body(body):
			if body.is_in_group("player") and PlayerDataSingleton.get_bounty() > 0:
				if behavior == Behaviors.FLEE:
					$Message.text = "HELP !"
				elif behavior == Behaviors.FIGHT:
					$Message.text = "HALT !"
				$AnimationPlayer.play("shout")
				_on_NPC_is_attacked(body)
				
func _on_NPC_is_attacked(attacker: PhysicsBody2D):
	PlayerDataSingleton.increment_bounty(10)
	if behavior == Behaviors.FLEE:
		## Would be better if avoided the player
		var rnd_dir := Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()
		var rnd_dist :=  rand_range(75, 150)
		_free_target.global_position = _pathfinder.get_closest_point(_root.global_position - rnd_dir * rnd_dist)
		_target = _free_target
	elif behavior == Behaviors.FIGHT:
		_target = attacker

func _on_Interactable_something_is_inside_interactable(body):
	if body == _target and behavior == Behaviors.FIGHT and !_attack_anim_is_playing:
		_attack_anim_is_playing = true	
		
func _on_AnimatedSprite_animation_finished():
	if _animated_sprite.animation.ends_with("MELEE_ATTACK"):
		_attack_anim_is_playing = false
		if $"../TalkingNPC/Interactable/ActionArea".overlaps_body(_target):
			_target.attack(1)