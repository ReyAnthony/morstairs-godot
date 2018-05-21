extends Control

var PLAYER_GOLD = 1500
var MERCHANT_GOLD = 1000

var MERCHANT_INVENTORY
var PLAYER_INVENTORY 

func _on_Quit_pressed():
	$ShopPopup.hide()
	get_tree().paused = false
	
func show_shop():
	MERCHANT_INVENTORY = $ShopPopup/Panel/Shop/Merchant/MerchantInventory
	PLAYER_INVENTORY = $ShopPopup/Panel/Shop/Player/PlayerInventory
	refresh_store()
	disable_buy_sell(true, true)
	select_first_stuff(MERCHANT_INVENTORY)
	select_first_stuff(PLAYER_INVENTORY)
	get_tree().paused = true
	update_gold_amounts()
	$ShopPopup.popup_centered()

func select_first_stuff(inventory):
	if inventory.get_item_count() > 0:
		inventory.select(0)
		#HACK => select won't fire signal ...
		#DOES NOT WORK
		if inventory == MERCHANT_INVENTORY: 
			_on_MerchantInventory_item_selected(0)
		else:
			_on_PlayerInventory_item_selected(0)

func refresh_store():
	MERCHANT_INVENTORY.clear()
	PLAYER_INVENTORY.clear()
	
	MERCHANT_INVENTORY.add_item("Sword - 50G")
	MERCHANT_INVENTORY.set_item_metadata(0, {"cost": 50, "type": "Weapon"})
	
	MERCHANT_INVENTORY.add_item("Sword - 2500G")
	MERCHANT_INVENTORY.set_item_metadata(1, {"cost": 2500, "type": "Weapon"})
	
	PLAYER_INVENTORY.add_item("Sword - 50G")
	PLAYER_INVENTORY.set_item_metadata(0, {"cost": 50, "type": "Weapon"})
	
	PLAYER_INVENTORY.add_item("Sword - 2500G")
	PLAYER_INVENTORY.set_item_metadata(1, {"cost": 2500, "type": "Weapon"})

func get_player_gold():
	return PLAYER_GOLD

func set_player_gold(amount):
	PLAYER_GOLD = amount
	
func get_merchant_gold():
	return MERCHANT_GOLD

func set_merchant_gold(amount):
	MERCHANT_GOLD = amount

func update_gold_amounts():
	$ShopPopup/Panel/Shop/GoldInfos/PlayerGold/Amount.text = String(get_player_gold())
	$ShopPopup/Panel/Shop/GoldInfos/MerchantGold/Amount.text = String(MERCHANT_GOLD)
	
func disable_buy_sell(buy, sell):
	$ShopPopup/Panel/Shop/Controls/Buy.disabled = buy
	$ShopPopup/Panel/Shop/Controls/Sell.disabled = sell	

func _on_Buy_pressed():
	disable_buy_sell(true, true)
	var idx = MERCHANT_INVENTORY.get_selected_items()[0]
	var cost = MERCHANT_INVENTORY.get_item_metadata(idx)["cost"]
	set_player_gold(get_player_gold() - cost)
	set_merchant_gold(get_merchant_gold() + cost)
	update_gold_amounts()
	MERCHANT_INVENTORY.remove_item(idx)
	refresh_store()

func _on_Sell_pressed():
	disable_buy_sell(true, true)
	var idx = PLAYER_INVENTORY.get_selected_items()[0]
	var cost = PLAYER_INVENTORY.get_item_metadata(idx)["cost"]
	set_merchant_gold(get_merchant_gold() - cost)
	set_player_gold(get_player_gold() + cost)
	update_gold_amounts()
	PLAYER_INVENTORY.remove_item(idx)
	refresh_store()

func _on_MerchantInventory_item_selected(index):
	print("selected merchant " + String(index)) 
	var cost = MERCHANT_INVENTORY.get_item_metadata(index)["cost"]
	print("Merchant cost " + String(cost))
	if cost <= get_player_gold():
		$ShopPopup/Panel/Shop/Controls/Buy.disabled = false
	else:
		$ShopPopup/Panel/Shop/Controls/Buy.disabled = true	

func _on_PlayerInventory_item_selected(index):
	print("selected player " + String(index)) 
	var cost = PLAYER_INVENTORY.get_item_metadata(index)["cost"]
	if cost <= get_merchant_gold():
		$ShopPopup/Panel/Shop/Controls/Sell.disabled = false
	else:
		$ShopPopup/Panel/Shop/Controls/Sell.disabled = true	