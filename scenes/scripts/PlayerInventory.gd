extends Control

var INVENTORY

func show_inventory():
	INVENTORY = $InventoryPopup/Panel/Inventory/Inventory
	update_player_infos()
	update_inventory_list()
	update_selection()
	$InventoryPopup.popup_centered()
	
func update_selection():
	if PlayerDataSingleton.objects.size() <= 0:
		$InventoryPopup/Panel/Inventory/ObjectInfoView.hide()
		$InventoryPopup/Panel/Inventory/ObjectActionsView.hide()
		$InventoryPopup/Panel/Inventory/Exit.grab_focus()
	else:
		$InventoryPopup/Panel/Inventory/Inventory.select(0)
		_on_Inventory_item_selected(0)	
		
func update_player_infos(): 
	$InventoryPopup/Panel/Inventory/PlayerInfoView/Name/Value.text = PlayerDataSingleton.get_player_name()
	$InventoryPopup/Panel/Inventory/PlayerInfoView/Gold/Value.text = String(PlayerDataSingleton.get_player_gold())
	$InventoryPopup/Panel/Inventory/PlayerInfoView/Bounty/Value.text = String(PlayerDataSingleton.get_bounty())
	
func update_inventory_list():
	INVENTORY.clear()
	var idx = 0
	for o in PlayerDataSingleton.objects:
		INVENTORY.add_item(o.name)
		INVENTORY.set_item_metadata(idx, o)
		idx += 1
		
func disable_object_actions(equip, unequip, throw_away):
	$InventoryPopup/Panel/Inventory/ObjectActionsView/Equip.disabled = equip
	$InventoryPopup/Panel/Inventory/ObjectActionsView/Unequip.disabled = unequip
	$InventoryPopup/Panel/Inventory/ObjectActionsView/Throw.disabled = throw_away
	
func update_object_info_view(index):
	$InventoryPopup/Panel/Inventory/ObjectInfoView.show()
	var metadata = INVENTORY.get_item_metadata(index)
	var cost = String(metadata.cost)
	$InventoryPopup/Panel/Inventory/ObjectInfoView/Cost/Value.text = cost 

func update_object_actions_view(index): 
	#TODO equipment
	var is_throwable = false
	
	var metadata = INVENTORY.get_item_metadata(index)
	if metadata.throwable:
		is_throwable = true
	disable_object_actions(true, true, !is_throwable)

func _on_Inventory_item_selected(index):
	update_object_info_view(index)
	update_object_actions_view(index)
	
func _on_Exit_pressed():
	$InventoryPopup.hide()
	get_tree().paused = false

func _on_Throw_pressed():
	#this only works because the inventory have a 1:1 mapping with the view list
	var index = INVENTORY.get_selected_items()[0]
	
	PlayerDataSingleton.objects.remove(index)
	update_inventory_list()
	update_selection()

func _on_Equip_pressed():
	pass # replace with function body

func _on_Unequip_pressed():
	pass # replace with function body
