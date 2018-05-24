extends Control

var PLAYER_GOLD = 1500
var MERCHANT_GOLD = 1000

var MERCHANT_INVENTORY
var PLAYER_INVENTORY 

func _on_Quit_pressed():
	$ShopPopup.hide()
	get_tree().paused = false
	
func show_shop():
	get_tree().paused = true
	MERCHANT_INVENTORY = $ShopPopup/Panel/Shop/Merchant/MerchantInventory
	PLAYER_INVENTORY = $ShopPopup/Panel/Shop/Player/PlayerInventory
	refresh_store()
	update_gold_amounts()
	$ShopPopup.popup_centered()

func select_first_stuff(inventory):
	if inventory.get_item_count() > 0:
		inventory.select(0)
		#HACK => select won't fire signal ...
		if inventory == MERCHANT_INVENTORY: 
			_on_MerchantInventory_item_selected(0)
		else:
			_on_PlayerInventory_item_selected(0)

func refresh_store():
	MERCHANT_INVENTORY.clear()
	PLAYER_INVENTORY.clear()
	
	MERCHANT_INVENTORY.add_item("Rusty Sword")
	MERCHANT_INVENTORY.set_item_metadata(0, 
	{"name": "Rusty Sword",
	 "cost": 50,
	 "throwable": true,
	 "infos": {} 
	 })
	
	MERCHANT_INVENTORY.add_item("Shiny Sword")
	MERCHANT_INVENTORY.set_item_metadata(1, 
	{"name": "Shiny Sword",
	 "cost": 2500,
	 "throwable": true,
	 "infos": {} 
	 })
	
	var idx = 0
	for o in PlayerDataSingleton.objects:
		PLAYER_INVENTORY.add_item(o.name)
		PLAYER_INVENTORY.set_item_metadata(idx, o)
		idx += 1
	
	select_first_stuff(MERCHANT_INVENTORY)
	select_first_stuff(PLAYER_INVENTORY)

func update_info_view(inventory, obj_data):
	var node = inventory.get_node("../Infos/Cost/Value")
	node.text = String(obj_data.cost)
	pass

func get_player_gold():
	return PlayerDataSingleton.gold

func set_player_gold(amount):
	PlayerDataSingleton.gold = amount
	
func get_merchant_gold():
	return MERCHANT_GOLD

func set_merchant_gold(amount):
	MERCHANT_GOLD = amount

func update_gold_amounts():
	$ShopPopup/Panel/Shop/GoldInfos/PlayerGold/Amount.text = String(get_player_gold())
	$ShopPopup/Panel/Shop/GoldInfos/MerchantGold/Amount.text = String(get_merchant_gold())
	
func disable_buy_sell(buy, sell):
	$ShopPopup/Panel/Shop/Controls/Buy.disabled = buy
	$ShopPopup/Panel/Shop/Controls/Sell.disabled = sell	

func _on_Buy_pressed():
	disable_buy_sell(true, true)
	var idx = MERCHANT_INVENTORY.get_selected_items()[0]
	var object = MERCHANT_INVENTORY.get_item_metadata(idx)
	var cost = object.cost
	MERCHANT_INVENTORY.remove_item(idx)
	
	PlayerDataSingleton.add_object_in_inventory(object)
	set_player_gold(get_player_gold() - cost)
	set_merchant_gold(get_merchant_gold() + cost)
	update_gold_amounts()
	refresh_store()

func _on_Sell_pressed():
	disable_buy_sell(true, true)
	var idx = PLAYER_INVENTORY.get_selected_items()[0]
	var object = PLAYER_INVENTORY.get_item_metadata(idx)
	var cost = object.cost
	PLAYER_INVENTORY.remove_item(idx)
	
	#same hack than in the inventory, mapping is 1:1 so ids are matching
	PlayerDataSingleton.remove_object_from_inventory(idx)
	set_merchant_gold(get_merchant_gold() - cost)
	set_player_gold(get_player_gold() + cost)
	update_gold_amounts()
	refresh_store()

func _on_MerchantInventory_item_selected(index):
	print("selected merchant " + String(index)) 
	var obj = MERCHANT_INVENTORY.get_item_metadata(index)
	var cost = obj.cost
	print("Merchant cost " + String(cost))
	if cost <= get_player_gold():
		$ShopPopup/Panel/Shop/Controls/Buy.disabled = false
	else:
		$ShopPopup/Panel/Shop/Controls/Buy.disabled = true
	update_info_view(MERCHANT_INVENTORY, obj)	

func _on_PlayerInventory_item_selected(index):
	print("selected player " + String(index)) 
	var obj = PLAYER_INVENTORY.get_item_metadata(index)
	var cost = obj.cost
	if cost <= get_merchant_gold() && obj.throwable:
		$ShopPopup/Panel/Shop/Controls/Sell.disabled = false
	else:
		$ShopPopup/Panel/Shop/Controls/Sell.disabled = true	
	update_info_view(PLAYER_INVENTORY, obj)	