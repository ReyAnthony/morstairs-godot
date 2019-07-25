extends KinematicBody2D

signal on_dialog_end

export (Material) var material_on_mouse_enter
export (String)  var chara_name
export (Texture) var chara_portrait
export (Array, String) var messages = []
export (Texture) var sprite

func get_stats():
	return $Stats

func _ready():
	$Sprite.texture = sprite
	$Interactable/Name.text = chara_name

func _on_DialogPanel_on_dialog_end():
	emit_signal("on_dialog_end")
	PlayerDataSingleton.clear_target()

func _on_Interactable_mouse_clicked():
	PlayerDataSingleton.set_target(self.global_position, self)

func _on_Interactable_mouse_entered():
	$Sprite.material = material_on_mouse_enter

func _on_Interactable_mouse_exited():
	$Sprite.material = null

func _on_Interactable_player_entered_while_interactable_is_targeted(body):
	if PlayerDataSingleton.get_target() == null:
		return
	if !PlayerDataSingleton.fight_mode && PlayerDataSingleton.get_target().node == self:
		$CanvasLayer/DialogPanel.my_popup(chara_name, chara_portrait, messages)
		PlayerDataSingleton.clear_target()
