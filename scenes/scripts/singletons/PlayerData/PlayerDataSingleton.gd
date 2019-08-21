extends Node
class_name PlayerDataSingleton

var player_portrait: Texture
var _player_name := "NAME"
var _player
var _target: PlayerTarget
var _bounty := 0
var _jail_time := 0 
var _fight_mode := false
var uiScene: PackedScene = preload("res://scenes/Scenes/PlayerUI.tscn")

signal target_has_changed
signal has_slept
signal bounty_paid
signal combat_mode_change

func _ready():
	_target = PlayerTarget.new(Vector2(0,0))
	_target.invalidate()
	player_portrait = preload("res://res/sprites/characters/player_portrait.png")
	_player = get_tree().get_nodes_in_group("player")[0]
	randomize()
	var scene = uiScene.instance()
	self.add_child(scene)
	
func _process(delta):
	OS.set_window_title("morstairs" + " | fps: " + str(Engine.get_frames_per_second()))
	
func set_target(global_position: Vector2, node: Node2D = null):
	if _target.is_valid():
		var current_pos := _target.get_position()
		if node == null: #we clicked on the ground
			#let's ignore the click if we clicked previously on a target and then we are clicking near it
			if current_pos.distance_to(global_position) < 5 and _target.targetType == PlayerTarget.TargetType.ACTION_TARGET:
				return
	_target = PlayerTarget.new(global_position, node)
	emit_signal("target_has_changed", _target)
	
func clear_target():
	_target.invalidate()
	emit_signal("target_has_changed", _target)
	
func get_target() -> PlayerTarget:
	assert(_target != null)
	return _target	
	
func get_player_name() -> String:
	return _player_name
	
func get_player_gold() -> int: 
	return get_chara_doll().get_gold()
	
func set_player_gold(gold: int):
	get_chara_doll().update_gold(gold)
		
func get_bounty() -> int:
	return _bounty

func increment_bounty(inc):
	_bounty += inc
	_jail_time = _bounty / 10

func can_pay_bounty() -> bool:
	return _bounty <=  get_player_gold()
	
func pay_bounty() -> bool:
	var can_pay = can_pay_bounty()
	if can_pay:
		get_chara_doll().update_gold(get_player_gold() - _bounty)
		_bounty = 0
		emit_signal("bounty_paid")
	return can_pay
	
func go_to_jail_reset_bounty():
	_bounty = 0
	emit_signal("bounty_paid")
	
func get_jail_time() -> int:
	return _jail_time

func decrement_jail_time():
	if _jail_time > 0:
		_jail_time -= 1
		
func heal_player():
	get_player().full_heal()
	
func has_slept():
	#update calendar
	emit_signal("has_slept")
	
func switch_fight_mode():
	_fight_mode = !_fight_mode
	emit_signal("combat_mode_change", _fight_mode)
	
func add_to_inventory(object: PickableObject):
	$PlayerUI.add_to_inventory(object)
	
func get_player() -> Player:
	return _player
	
func get_chara_doll() -> CharaDoll:
	return $PlayerUI.get_chara_doll()
	
func get_stats() -> CharaDoll:
	return $PlayerUI.get_chara_doll().get_stats()	
	
func get_inventory() -> Inventory:
	return $PlayerUI/PlayerInventory as Inventory
	
func get_player_ui_manager() -> PlayerUIManager:
	return $PlayerUI as PlayerUIManager

func is_fighting() -> bool:
	return _fight_mode	
	
func game_over():
	assert(false) ##HIDE UI
