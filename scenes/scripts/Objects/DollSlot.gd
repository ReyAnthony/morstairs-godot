extends Slot
class_name DollSlot

const ObjectType = preload("res://scenes/scripts/Objects/ObjectType.gd").ObjectType
var _inventory_info_panel: InventoryInfoPanel
export (ObjectType) var slot_type: int

func _ready():
	_inventory_info_panel = $"../../../InfoPanel"
	_inventory_info_panel.reset()
	
func get_drag_data(position):
	if !is_empty() and get_object_in_slot().get_type() == ObjectType.COIN:
		return null #can't drag cash once it's in your inventory
	return .get_drag_data(position)

func can_drop_data(position, data):
	var ret = .can_drop_data(position, data)
	return ret and data.get_type() == slot_type
	
func _on_mouse_entered():
	._on_mouse_entered()
	if is_empty():
		return
	var o = get_object_in_slot()
	_inventory_info_panel.update_panel(o)

func _on_mouse_exited():
	._on_mouse_exited()
	##_inventory_info_panel.reset()
	pass
	
func drop_data(position, data):
	##allow moving from inventory slot to doll slot even if full
	var player_inventory = $"../../../"
	var bag = $"../../../Bag"
	var chara_doll = $"../../"
	if player_inventory._is_it_too_heavy_with_new(data) and data.get_parent() is LootSlot:
		player_inventory.show_is_full()
		return
	.drop_data(position, data)