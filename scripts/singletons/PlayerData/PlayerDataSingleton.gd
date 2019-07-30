extends Node
class_name PDS

var _player_name := "UNKNOWN"
var _gold := 500
var _target: PlayerTarget

var fight_mode := false

func set_target(global_position: Vector2, node: Node2D):
	_target = PlayerTarget.new(global_position, node)
	
func clear_target():
	_target = null
	
func get_target() -> PlayerTarget:
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