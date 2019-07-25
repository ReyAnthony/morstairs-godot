extends Node

#objects that can't be thrown away can't be sold either
var objects = [
	ObjectHelper.make_player_inventory_object("Shield", 100, true, true),
	ObjectHelper.make_player_inventory_object("Useless annoying object", 0, false, false),
	ObjectHelper.make_player_inventory_object("Useless annoying object", 0, false, false),
	ObjectHelper.make_player_inventory_object("Useless object", 150, true, false)
]

var player_name = "UNKNOWN"
var gold = 500

var target
var fight_mode = false

func set_target(global_position, node):
	target = {"position": global_position, "node": node}
	
func clear_target():
	target = null
	
func get_target():
	return self.target	
	
func get_player_gold(): 
	return self.gold
	
func set_player_gold(gold):
	if gold > 0:
		self.gold = gold
	else:
		self.gold = 0	

func add_object_in_inventory(obj): 
	objects.push_back(obj)
	
func remove_object_from_inventory(obj):
	objects.remove(obj)