extends KinematicBody2D
class_name Player

export (Texture) var player_portrait: Texture

const _WALK_SPEED := 30
const _PDS: PDS = PlayerDataSingleton
var _velocity := Vector2()
var _is_attacking := false
var _last_dir := "NW"
var _pathfind := []
var _pathfinder: NavigationTilemap
var _path_index := 0

var _line : Line2D

func attack(amount: int):
	$Stats.attack(amount)

func _ready():
	set_process(true)
	$AnimatedSprite.play("NW")
	add_to_group("player")
	$Interactable.connect("something_is_inside_interactable", self, "_on_player_npc_is_inside_action_zone")
	$AnimatedSprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")
	$CanvasLayer/Panel/CombatMode.connect("pressed", self, "_on_combat_mode_switch")
	$CanvasLayer/Panel/Inventory.connect("pressed", self, "_on_show_inventory")
	PlayerDataSingleton.connect("target_has_changed", self, "_target_changed")
	_clear_player_selection()
	_pathfinder = get_tree().get_nodes_in_group("nav")[0]
	_line = $"/root/Level/Line2D" as Line2D
	
##TODO pathfind each 250ms for moving targets	
func _process(delta: float):
	var anim_direction := ""
	var anim := ""
	var target: PlayerTarget = _PDS.get_target()
	_update_player_life()
		
	if target.is_valid():
		if _pathfind.empty():
			_clear_target_reset_velocity()
		else:	
			if global_position.distance_to(_pathfind[_path_index]) < 1 and _path_index <= _pathfind.size() - 1:
				_path_index += 1	
				
			if _path_index >= _pathfind.size():
				_clear_target_reset_velocity()
			else:		
				_velocity = (_pathfind[_path_index] - self.global_position).normalized()
				anim_direction += _determine_sprite_direction()
				if target.is_valid() and target.targetType == target.TargetType.ACTION_TARGET and target.node.is_in_group("npc"):
					if !$Interactable/ActionArea.overlaps_body(target.node):
						_is_attacking = false
	else:
		_is_attacking = false
		_clear_target_reset_velocity()

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

func _clear_target_reset_velocity():
	_PDS.clear_target()
	_velocity.x = 0
	_velocity.y = 0

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

func _unhandled_input(event: InputEvent):
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
	else:
		$AnimatedSprite.play(_last_dir + "_FIGHT")
	_PDS.fight_mode = !_PDS.fight_mode
	
func _clear_player_selection():
	$Interactable.show_name = false
	$Interactable.hide_name()
	
func _on_show_inventory():
	get_tree().paused = true
	$CanvasLayer/PlayerInventory.show_inventory()

func _target_changed():
	var target: PlayerTarget = _PDS.get_target()
	_pathfind = _pathfinder.get_the_path(self.global_position, target.get_position())
	if !_pathfind.empty():
		_path_index = 0
		_pathfind.remove(0)
		_line.clear_points()
		for n in _pathfind:
			_line.add_point(n)
	_update_targeting(target)

func _update_targeting(target: PlayerTarget):
	if target.is_valid() and target.targetType == target.TargetType.ACTION_TARGET and _PDS.fight_mode and target.node.can_be_hit:
		$CanvasLayer/Life/Target.show()
		$CanvasLayer/Life/Target/Label.text = target.node.chara_name
		$CanvasLayer/Life/Target/Portrait.texture = target.node.chara_portrait
		$CanvasLayer/Life/Target/ColorRect.rect_size.x = target.node.get_life() * (77 / target.node.get_max_life())
	else:
		$CanvasLayer/Life/Target.hide()
		
func _update_player_life():
	if $Stats._current_life < $Stats.life:
		$CanvasLayer/Life/Player.show()
		$CanvasLayer/Life/Player/Label.text = _PDS.get_player_name()
		$CanvasLayer/Life/Player/Portrait.texture = player_portrait
		$CanvasLayer/Life/Player/ColorRect.rect_size.x = $Stats._current_life * (77 / $Stats.life)
	else:
		$CanvasLayer/Life/Player.hide()	