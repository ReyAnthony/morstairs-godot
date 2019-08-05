extends Node
class_name PDS

var _player_name := "UNKNOWN"
var _gold := 500
var _target: PlayerTarget
var _bounty := 0
var fight_mode := false

signal target_has_changed

func _ready():
	_target = PlayerTarget.new(Vector2(0,0))
	_target.invalidate()
	randomize()

func set_target(global_position: Vector2, node: Node2D = null):
	_target = PlayerTarget.new(global_position, node)
	emit_signal("target_has_changed")

func clear_target():
	_target.invalidate()
	
func get_target() -> PlayerTarget:
	assert(_target != null)
	return _target	
	
func get_player_name() -> String:
	return _player_name
	
func get_player_gold() -> int: 
	return _gold
	
func set_player_gold(gold: int):
	if gold > 0:
		_gold = gold
	else:
		_gold = 0
		
func get_bounty() -> int:
	return _bounty

func increment_bounty(inc):
	_bounty += inc

func can_pay_bounty() -> bool:
	return _bounty <= _gold
	
func pay_bounty() -> bool:
	var can_pay = can_pay_bounty()
	if can_pay:
		_gold -= _bounty
	return can_pay

#TODO rework inventory
#objects that can't be thrown away can't be sold either
var objects = [
	ObjectHelper.make_player_inventory_object("Shield", 100, true, true),
	ObjectHelper.make_player_inventory_object("Useless annoying object", 0, false, false),
	ObjectHelper.make_player_inventory_object("Useless annoying object", 0, false, false),
	ObjectHelper.make_player_inventory_object("Useless object", 150, true, false)
]

func add_object_in_inventory(obj): 
	objects.push_back(obj)
	
func remove_object_from_inventory(obj):
	objects.remove(obj)