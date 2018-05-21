extends Node2D

export (String)  var chara_name
export (Texture) var chara_portrait
export (Array, String) var messages = []

func _ready():
	$TalkingNPC.chara_name = chara_name
	$TalkingNPC.chara_portrait = chara_portrait
	$TalkingNPC.messages = messages

func _on_TalkingNPC_on_dialog_end():
	$CanvasLayer/Shop.show_shop()