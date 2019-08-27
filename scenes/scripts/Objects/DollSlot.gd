extends Slot
class_name DollSlot

const ObjectType = preload("res://scenes/scripts/Objects/ObjectType.gd").ObjectType
const SubType = preload("res://scenes/scripts/Objects/ObjectType.gd").SubType
var _inventory_info_panel: InventoryInfoPanel
export (ObjectType) var slot_type: int

func _ready():
	_inventory_info_panel = $"../../../InfoPanel"
	_inventory_info_panel.reset()
	assert($"../CantDoThisInFightMode")
	assert($"../CantEquipABowWithAShield")
	
func get_drag_data(position):
	if !is_empty() and get_object_in_slot().get_type() == ObjectType.COIN:
		return null #can't drag cash once it's in your inventory
	##can't drag stuff from the charadoll when in combat mode
	if PDS.is_fighting():
		DS.spawn_dialog("", null, $"../CantDoThisInFightMode")
		return null	
	return .get_drag_data(position)

func can_drop_data(position, data):
	assert(data is PickableObject)
	var ret = .can_drop_data(position, data)
	return ret and data.get_type() == slot_type  #can't drop stuff to when combat
	
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
	if(PDS.is_fighting() and data.get_type() == slot_type and slot_type != ObjectType.AMMO):
		DS.spawn_dialog("", null, $"../CantDoThisInFightMode")
		return
	if slot_type == ObjectType.WEAPON and data.get_subtype() == SubType.RANGED:
		if ($"../../" as CharaDoll).has_shield():
			DS.spawn_dialog("", null, $"../CantEquipABowWithAShield")
			return
	if slot_type == ObjectType.SHIELD:
		if ($"../../" as CharaDoll).has_ranged_weapon():
			DS.spawn_dialog("", null, $"../CantEquipABowWithAShield")
			return
	
	##allow moving from inventory slot to doll slot even if full
	var player_inventory = $"../../../"
	var bag = $"../../../Bag"
	var chara_doll = $"../../"
	if player_inventory._is_it_too_heavy_with_new(data) and data.get_parent() is LootSlot:
		player_inventory.show_is_full()
		return
	.drop_data(position, data)