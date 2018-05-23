extends Control

var INVENTORY

func show_inventory():
	INVENTORY = $InventoryPopup/Panel/Inventory/Inventory
	INVENTORY.clear()
	update_inventory_list()
	if PlayerDataSingleton.objects.size() <= 0:
		$InventoryPopup/Panel/Inventory/ObjectInfoView.hide()
	else:
		$InventoryPopup/Panel/Inventory/Inventory.select(0)
		_on_Inventory_item_selected(0)
	$InventoryPopup.popup_centered()
	
func update_inventory_list():
	var idx = 0
	for o in PlayerDataSingleton.objects:
		INVENTORY.add_item(o.name)
		INVENTORY.set_item_metadata(idx, {"cost": o.cost, "infos": o.infos})
		idx += 1

func update_object_info_view(index):
	$InventoryPopup/Panel/Inventory/ObjectInfoView.show()
	var metadata = INVENTORY.get_item_metadata(index)
	var cost = String(metadata.cost)
	$InventoryPopup/Panel/Inventory/ObjectInfoView/Cost/Value.text = cost 

func _on_Inventory_item_selected(index):
	update_object_info_view(index)
	
func _on_Exit_pressed():
	$InventoryPopup.hide()
	get_tree().paused = false
