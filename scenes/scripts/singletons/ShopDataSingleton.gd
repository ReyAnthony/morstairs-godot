extends Node

var shops_inventories = {
	"MORSTAIRS_TOWN_SELLER": 
	[
	ObjectHelper.make_store_inventory_object("An object", 100, true, true, true),
	ObjectHelper.make_store_inventory_object("Another one", 2500, true, true, true),
	ObjectHelper.make_store_inventory_object("Another obj", 50, true, true, false)
	],
	"MORSTAIRS_BLACKMARKET_SELLER": 
	[
	#can't sell black market object back
	ObjectHelper.make_store_inventory_object("Powerful Illegal Object", 10000, false, true, false)
	]
}

var shop_settings = {
	"MORSTAIRS_TOWN_SELLER": {"price_tag_modifier_percent": 10, "gold": 1000},
	"MORSTAIRS_BLACKMARKET_SELLER":  {"price_tag_modifier_percent": 50, "gold": 10000}
}

func add_object_in_inventory(merchant_id, object):
	var merchant = shops_inventories[merchant_id]
	var infinite_supply = false
	if "infinite_supply" in object: 
		infinite_supply = object.infinite_supply
	if !infinite_supply && !merchant.has(object):
		merchant.push_back(ObjectHelper.make_store_inventory_object_from_object(object, false))

func remove_object_from_inventory(merchant_id, object_id):
	var merchant = shops_inventories[merchant_id]
	if !merchant[object_id].infinite_supply:
		merchant.remove(object_id)
		
func get_shop_objects(merchant_id):
	var merchant = shops_inventories[merchant_id]
	return merchant
	
func get_merchant_gold(merchant_id): 
	return shop_settings[merchant_id].gold
	
func set_merchant_gold(merchant_id, gold):
	shop_settings[merchant_id].gold = gold
	
func get_share(modifier, price):
	var new_price = ((price / 100) * modifier)	
	if new_price < 0:
		return 0
	return new_price
	
func apply_pricetag_modifier_for_merchant(merchant_id, price):
	var modifier = shop_settings[merchant_id].price_tag_modifier_percent
	return price + get_share(modifier, price)
	
func apply_pricetag_modifier_for_player(merchant_id, price):
	var modifier = shop_settings[merchant_id].price_tag_modifier_percent
	return price - get_share(modifier, price)