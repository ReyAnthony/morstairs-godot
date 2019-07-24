extends KinematicBody2D

signal on_dialog_end

export (Material) var material_on_mouse_enter
export (String)  var chara_name
export (Texture) var chara_portrait
export (Array, String) var messages = []
export (Texture) var sprite

func _ready():
	$Sprite.texture = sprite

func _on_DialogPanel_on_dialog_end():
	emit_signal("on_dialog_end")
	PlayerDataSingleton.clear_target()

func _on_MouseArea_mouse_entered():
	$Sprite.material = material_on_mouse_enter

func _on_MouseArea_mouse_exited():
	$Sprite.material = null

func _on_MouseArea_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("mouse_left_click"):
		PlayerDataSingleton.set_target(self.global_position, self)
		
func _on_ActionArea_body_entered(body):
	if body.is_in_group("player") && !PlayerDataSingleton.fight_mode \
						          && PlayerDataSingleton.get_target().node == self:
		$CanvasLayer/DialogPanel.my_popup(chara_name, chara_portrait, messages)
		PlayerDataSingleton.clear_target()
