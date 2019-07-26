extends Node2D

export (String)  var merchant_id

func _ready():
	$TalkingNPC.connect("on_dialog_end", self, "_on_TalkingNPC_on_dialog_end")

func _on_TalkingNPC_on_dialog_end():
	$ShopUI/Shop.show_shop(merchant_id)