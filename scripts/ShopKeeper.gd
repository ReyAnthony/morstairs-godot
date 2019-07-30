extends Node2D
class_name ShopKeeper

export (String)  var merchant_id: String

func _ready():
	$TalkingNPC.connect("on_dialog_end", self, "_on_TalkingNPC_on_dialog_end")

func _on_TalkingNPC_on_dialog_end():
	$ShopUI/Shop.show_shop(merchant_id)