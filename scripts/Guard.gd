extends Sprite

export (String)  var chara_name
export (Texture) var chara_portrait
export (Array, String) var messages = []

	
func _on_Action_accept_pressed():
	$CanvasLayer/DialogPanel.popup(chara_name, chara_portrait, messages)
