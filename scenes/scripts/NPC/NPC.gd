extends GameObjectBase
class_name NPC

signal on_dialog_end
signal is_attacked(attacker)

export (String)  var chara_name: String
export (Texture) var chara_portrait: Texture
export (NodePath) var override_dialog: NodePath

func _ready():
	assert($Sprite != null)
	assert($DialogMessage)
	self.add_to_group("npc")
	if has_node("NPCDoll/Stats"):
		can_be_hit = true
	PDS.connect("target_has_changed", self, "_on_player_target_changed")
	$Interactable/Name.text = chara_name
	if !override_dialog.is_empty():
		assert(get_children().has(get_node(override_dialog)))
	
##MERGE STATS AND DOLL ??
func attack(attackerDoll: Doll, attacker: PhysicsBody2D):
	assert($NPCDoll.get_stats())
	var dmg = attackerDoll.get_damages(get_doll())
	$NPCDoll.get_stats().attack(dmg)
	emit_signal("is_attacked", attacker)
	
func get_doll() -> Doll:
	return $NPCDoll as Doll
	
func get_life() -> int:
	assert($NPCDoll.get_stats())
	return $NPCDoll.get_stats()._current_life
	
func get_max_life() -> int:
	assert($NPCDoll.get_stats())
	return $NPCDoll.get_stats().life
	
func _on_DialogPanel_on_dialog_end():
	PDS.clear_target()
	if PDS.get_bounty() <= 0:
		emit_signal("on_dialog_end")

func _on_player_target_changed(target: PlayerTarget):
	if target.is_you(self) and can_be_hit and target.is_valid():
		$Sprite.material = material_on_target
	else:
		$Sprite.material = null
		
func _on_Interactable_something_is_inside_interactable(body: PhysicsBody2D):
	if !PDS.get_target().is_valid():
		return
	if !PDS.is_fighting() && PDS.get_target().is_you(self):
		if PDS.get_bounty() > 0 and can_be_hit and $BountyMessages != null:
			DS.spawn_dialog(chara_name, chara_portrait, $BountyMessages)
		else:
			if !override_dialog.is_empty():
				DS.spawn_dialog(chara_name, chara_portrait, get_node(override_dialog))
			else:
				DS.spawn_dialog(chara_name, chara_portrait, $DialogMessage)
		PDS.clear_target()
