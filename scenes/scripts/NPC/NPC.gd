extends KinematicBody2D
class_name NPC

signal on_dialog_end
signal is_attacked(attacker)

export (Material) var material_on_mouse_enter: Material
export (Material) var material_on_target: Material
export (String)  var chara_name: String
export (Texture) var chara_portrait: Texture

var can_be_hit := false

func _ready():
	assert($Sprite != null)
	assert($Interactable != null)
	assert($DialogMessage)
	self.add_to_group("npc")
	if $Stats != null:
		can_be_hit = true

	$Interactable.connect("mouse_clicked", self, "_on_Interactable_mouse_clicked")
	$Interactable.connect("mouse_entered", self,  "_on_Interactable_mouse_entered")
	$Interactable.connect("mouse_exited", self, "_on_Interactable_mouse_exited")
	$Interactable.connect("something_is_inside_interactable", self, "_on_Interactable_something_is_inside_interactable")
	PlayerDataSingleton.connect("target_has_changed", self, "_on_player_target_changed")
	$Interactable/Name.text = chara_name
	
func attack(amount: int, attacker: PhysicsBody2D):
	$Stats.attack(amount)
	emit_signal("is_attacked", attacker)
	
func get_life() -> int:
	return $Stats._current_life
	
func get_max_life() -> int:
	return $Stats.life	
	
func _on_DialogPanel_on_dialog_end():
	PlayerDataSingleton.clear_target()
	if PlayerDataSingleton.get_bounty() <= 0:
		emit_signal("on_dialog_end")

func _on_Interactable_mouse_clicked():
	PlayerDataSingleton.set_target(global_position, self)

func _on_Interactable_mouse_entered():
	if !PlayerDataSingleton.get_target().is_you(self):
		$Sprite.material = material_on_mouse_enter

func _on_Interactable_mouse_exited():
	if $Sprite.material == material_on_mouse_enter:
		$Sprite.material = null
	
func _on_player_target_changed(target: PlayerTarget):
	if target.is_you(self) and can_be_hit:
		$Sprite.material = material_on_target
	else:
		$Sprite.material = null
		
func _on_Interactable_something_is_inside_interactable(body: PhysicsBody2D):
	if !PlayerDataSingleton.get_target().is_valid():
		return
	
	if !PlayerDataSingleton.fight_mode && PlayerDataSingleton.get_target().node == self:
		if PlayerDataSingleton.get_bounty() > 0 and can_be_hit:
			pass
			##($CanvasLayer/DialogPanel as DialogPanel).my_popup(chara_name, chara_portrait, [chara_name + " n'a plus rien a vous dire."])
		else:
			pass
			($CanvasLayer/DialogPanel as DialogPanel).my_popup(chara_name, chara_portrait, $DialogMessage)
		PlayerDataSingleton.clear_target()
