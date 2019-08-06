extends Node2D
class_name NPCBehavior

enum IdleBehaviors {
	WANDERING,
	IDLE
}

enum FightingBehaviors {
	FLEE,
	FIGHT,
	GO_BACK_IDLE
}

export (IdleBehaviors) var idle_behavior
export (FightingBehaviors) var fighting_behavior

var _initial_position: Vector2
var _go_back_to_initial_position := false
var _initial_dir := ""
var _target: Node2D
var _root: KinematicBody2D
var _last_dir := "SE"
var _attack_anim_is_playing := false
var _animated_sprite :AnimatedSprite
var _pathfinder: Navigation2D
var _free_target: Node2D
var _viewArea: Area2D
var pathfind := []
var _velocity: Vector2 = Vector2(0, 0)
var _player : Player

var _last_pathfind_time: float
var _attacked = false
var _current_pathfind_index :int = 0

#debug
var _debug := true
var _line : Line2D

func _ready():
	assert($"../" is KinematicBody2D)
	assert($"../Sprite" != null)
	assert($"../Sprite" is AnimatedSprite)
	assert($"../Collision" != null)
	assert($"../Collision" is CollisionPolygon2D)
	assert($ViewArea != null)
	
	_root = $"../"
	_animated_sprite = $"../Sprite"
	_free_target = Node2D.new()
	_free_target.name = "free_target"
	$"../../".call_deferred("add_child", _free_target)
	_free_target.call_deferred("global_position", Vector2(0, 0))

	_pathfinder = get_tree().get_nodes_in_group("nav")[0]
	_initial_position = _root.global_position
	_initial_dir = _last_dir
	_line = $"/root/Level/Line2D" as Line2D
	_viewArea = $ViewArea
	_player = get_tree().get_nodes_in_group("player")[0]
	
	_root.connect("is_attacked", self, "_on_NPC_is_attacked")
	$"../Interactable".connect("something_is_inside_interactable", self, "_on_Interactable_something_is_inside_interactable")
	_animated_sprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")
	#_root.add_collision_exception_with($"../TalkingNPC")
	z_index = 255
	
func _process(delta):
	if !is_instance_valid(_animated_sprite):
			return
			
	var anim_direction := ""
	var atk := ""
	
	if _attacked:
		if PlayerDataSingleton.get_bounty() <= 0:
			_go_back_to_initial_position()
		if fighting_behavior == FightingBehaviors.FIGHT:
			if (_last_pathfind_time > 0.250 or pathfind.empty() or global_position.distance_to(pathfind[0]) <= 2):
				_pathfind()
				_last_pathfind_time = 0
			else:
				_last_pathfind_time += delta
			_velocity = (pathfind[0] - _root.global_position).normalized()
			if(_root.global_position.distance_to(_target.global_position) > 75):
				_go_back_to_initial_position()
		elif fighting_behavior == FightingBehaviors.FLEE:
			if _unroll_pathfind_done():
				_go_back_to_initial_position()
	else:
		if $ViewArea.overlaps_body(_player):
			if PlayerDataSingleton.get_bounty() > 0:
				if fighting_behavior == FightingBehaviors.FLEE:
					match randi() % 2 :
						0: $Message.text = "HELP !"
						1: $Message.text = "GUARDS !"
				elif fighting_behavior == FightingBehaviors.FIGHT:
					match randi() % 5 :
						0: $Message.text = "HALT !"
						1: $Message.text = "FOR THE KING !"
						2: $Message.text = "THOU WILL PAY !"
						3: $Message.text = "MISCREANT !"
						4: $Message.text = "SCUM !"
				$AnimationPlayer.play("shout")
				_npc_attack(_player)
		
		if _go_back_to_initial_position:
			if _unroll_pathfind_done():
				_go_back_to_initial_position = false
				_target = null
				_animated_sprite.play(_initial_dir)
		else:
				if idle_behavior == IdleBehaviors.IDLE:
					_velocity = Vector2(0,0)
					pass
				elif idle_behavior == IdleBehaviors.WANDERING:
					#_pathfind()
					##TODO WANDERING AUSSI (comme flee)	
					pass #go back to initial position
	
	anim_direction += _determine_sprite_direction()
	if anim_direction != "":
		_last_dir = anim_direction
		if fighting_behavior == FightingBehaviors.FIGHT:
			anim_direction += "_FIGHT"
		if _attack_anim_is_playing:
			atk = "_MELEE_ATTACK"
		_animated_sprite.play(anim_direction + atk)
		
	if _velocity.length() < 0.1:
		_animated_sprite.stop()
		_animated_sprite.frame = 0
		
	if !(fighting_behavior == FightingBehaviors.FIGHT and _attacked and _attack_anim_is_playing):
		_root.move_and_slide(_velocity.normalized() * 20, Vector2.ZERO, false, 100)
	for i in _root.get_slide_count():
		var collision: KinematicCollision2D = _root.get_slide_collision(i)
		if fighting_behavior == FightingBehaviors.FLEE and _attacked:
			_npc_attack(_player)
			break;
				
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

func _go_back_to_initial_position():
	_attacked = false
	_go_back_to_initial_position = true
	_free_target.global_position = _initial_position
	_target = _free_target
	_pathfind()

func _unroll_pathfind_done():
	if _current_pathfind_index >= pathfind.size() -1:
			_current_pathfind_index = 0
			return true
	else:
		if _root.global_position.distance_to(pathfind[_current_pathfind_index]) <= 2:
			_current_pathfind_index += 1
		_velocity = (pathfind[_current_pathfind_index] - _root.global_position).normalized()
		return false

func _pathfind(): 
	pathfind = _pathfinder.get_simple_path(_root.global_position, _target.global_position, false)
	assert(!pathfind.empty())
	if _debug:
		_line.clear_points()
		for n in pathfind:
			_line.add_point(n)
	pathfind.remove(0)
	
func _on_NPC_is_attacked(attacker: PhysicsBody2D):
	PlayerDataSingleton.increment_bounty(10)
	_npc_attack(attacker)

func _npc_attack(attacker: PhysicsBody2D):
	_attacked = true
	_go_back_to_initial_position = false
	if fighting_behavior == FightingBehaviors.GO_BACK_IDLE:
		_attacked = false
		return 
	elif fighting_behavior == FightingBehaviors.FLEE:
		## Would be better if avoided the player
		var rnd_dir := Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()
		var rnd_dist :=  rand_range(75, 150)
		_free_target.global_position = _pathfinder.get_closest_point(_root.global_position - rnd_dir * rnd_dist)
		_target = _free_target
	elif fighting_behavior == FightingBehaviors.FIGHT:
		_target = attacker
	_pathfind()	

func _on_Interactable_something_is_inside_interactable(body):
	if body == _target and fighting_behavior == FightingBehaviors.FIGHT and !_attack_anim_is_playing:
		_attack_anim_is_playing = true	
		
func _on_AnimatedSprite_animation_finished():
	if _animated_sprite.animation.ends_with("MELEE_ATTACK"):
		_attack_anim_is_playing = false
		if $"../Interactable/ActionArea".overlaps_body(_target):
			_target.attack(1)