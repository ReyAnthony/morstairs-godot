extends Node

func make_player_inventory_object(name, cost, throwable, equipable):
	return {"name": name, "cost": cost, "throwable": throwable, "equipable": equipable, "infos": {}}
	
func make_store_inventory_object(name, cost, equipable, throwable, infinite_supply):
	var obj = make_player_inventory_object(name, cost, throwable, equipable)
	obj.infinite_supply = infinite_supply
	return obj
	
func make_store_inventory_object_from_object(object, infinite_supply):
	object.infinite_supply = infinite_supply
	return object
	
func add_object_in_list_view(inventory, list_view):
	var idx = 0
	for o in inventory:
		list_view.add_item(o.name)
		list_view.set_item_metadata(idx, o)
		idx += 1