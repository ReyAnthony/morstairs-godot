extends CanvasLayer
class_name PlayerUIManager

var charadoll_button
var inventory_button
var inventory_ui
var combat_button

var _parent_for_loot: Node

func _ready():
	pause_mode = PAUSE_MODE_PROCESS
	charadoll_button = $Panel/Player/Portrait
	charadoll_button.connect("pressed", self, "_on_inventory_pressed")
	
	inventory_button = $Panel/Inventory
	inventory_ui = $PlayerInventory
	inventory_button.connect("pressed", self, "_on_inventory_pressed")
	
	combat_button = $Panel/CombatMode
	combat_button.connect("pressed", self, "_on_combat_mode_switch")
	PDS.connect("target_has_changed", self, "_update_targeting")
	PDS.get_player().get_stats().connect("life_changed", self, "_update_player_life")
	
func add_to_inventory(object: PickableObject):
	$PlayerInventory.add_to_inventory(object)
		
func get_chara_doll() -> CharaDoll:
	return $PlayerInventory.get_chara_doll() as CharaDoll
	
func show_inventory_and_loot(loot: Array, parent: Node):
	_parent_for_loot = parent
	_on_inventory_pressed()
	show_loot(loot)
	
func show_loot(loot: Array):
	$PlayerInventory.update_loot(loot)
	$PlayerInventory.show_loot()

func hide_loot():
	$PlayerInventory.hide_loot()
	
func _on_combat_mode_switch():
	PDS.clear_target()
	PDS.switch_fight_mode()

func _on_inventory_pressed():
	if inventory_ui.visible:
		close_inventory()
		_show_combat_mode()
		get_tree().paused = false
	else:
		_hide_combat_mode()
		show_inventory()
		get_tree().paused = true
		
func show_inventory():
	PDS.clear_target()
	hide_loot()
	inventory_button.pressed = true
	inventory_ui.show()
	
func close_inventory():
	inventory_ui.hide()
	$PlayerInventory.clear_loot(_parent_for_loot)
	
func _hide_combat_mode():
	$Panel/CombatMode.hide()
	
func _show_combat_mode():
	$Panel/CombatMode.show()
	
func _update_player_life():
	var stats = PDS.get_player().get_stats()
	$Panel/Player/Label.text = PDS.get_player_name()
	$Panel/Player/ColorRect.rect_size.x = stats._current_life * (77 / stats.life)	
	
func _update_targeting(t = null):
	var target: PlayerTarget = PDS.get_target()
	if target.is_valid() and target.targetType == target.TargetType.ACTION_TARGET and target.node.can_be_hit:
		$Life/Target.show()
		$Life/Target/Label.text = target.node.chara_name
		$Life/Target/Portrait.texture = target.node.chara_portrait
		$Life/Target/ColorRect.rect_size.x = target.node.get_life() * (77 / target.node.get_max_life())
	else:
		$Life/Target.hide()