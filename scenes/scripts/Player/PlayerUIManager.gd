extends CanvasLayer
class_name PlayerUIManager

var charadoll_button
var inventory_button
var inventory_ui
var combat_button
var pause_ui
var pause_button

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
	
	pause_button = $Panel/Pause
	pause_ui = $PauseUI
	pause_button.connect("pressed", self, "_on_pause_pressed")
	
	PDS.connect("target_has_changed", self, "_update_targeting")
	
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
		show_all_buttons()
		get_tree().paused = false
	else:
		_hide_combat_mode()
		pause_button.hide()
		show_inventory()
		get_tree().paused = true
		
func _on_pause_pressed():
	if !pause_ui.visible:
		get_tree().paused = true
		pause_ui.show()
		hide_all_buttons_but_pause()
	else:
		get_tree().paused = false
		pause_ui.hide()
		show_all_buttons()

func hide_all_buttons_but_pause():
	inventory_button.hide()
	combat_button.hide()
	$Panel/Player.hide()
	
func show_all_buttons():
	inventory_button.show()
	combat_button.show()
	$Panel/Player.show()
	pause_button.show()

func show_inventory():
	$PlayerInventory/InfoPanel.reset()
	PDS.clear_target()
	hide_loot()
	inventory_button.pressed = true
	inventory_ui.show()
	
func close_inventory():
	inventory_ui.hide()
	inventory_button.pressed = false
	$PlayerInventory.clear_loot(_parent_for_loot)
	
func _hide_combat_mode():
	combat_button.hide()
	
func _show_combat_mode():
	combat_button.show()
	
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