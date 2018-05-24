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

func add_object_in_inventory(obj): 
	objects.push_back(obj)
	
func remove_object_from_inventory(obj):
	objects.remove(obj)