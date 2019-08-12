extends CanvasLayer

var charadoll_button
var charadoll_ui
var inventory_button
var inventory_ui
var combat_button

func _ready():
	pause_mode = PAUSE_MODE_PROCESS
	charadoll_button = $Panel/Player/Portrait
	charadoll_ui = $PlayerInventory/CharaDoll
	charadoll_button.connect("pressed", self, "_on_charadoll_pressed")
	
	inventory_button = $Panel/Inventory
	inventory_ui = $PlayerInventory
	inventory_button.connect("pressed", self, "_on_inventory_pressed")
	
	combat_button = $Panel/CombatMode
	combat_button.connect("pressed", self, "_on_combat_mode_switch")
	PDS.connect("target_has_changed", self, "_update_targeting")
	PDS.get_player().get_stats().connect("life_changed", self, "_update_player_life")
	
func _process(delta):
	#maybe not needed?
	##_update_targeting()
	pass
	
func _on_combat_mode_switch():
	PDS.clear_target()
	PDS.switch_fight_mode()

func _on_charadoll_pressed():
	if charadoll_ui.visible:
		if !inventory_ui.visible:
			 _show_combat_mode()
			 get_tree().paused = false
		hide_charadoll()
	else:
		_hide_combat_mode()
		show_charadoll()
		get_tree().paused = true
		
func _on_inventory_pressed():
	if inventory_ui.visible:
		close_inventory()
		if !charadoll_ui.visible:
			_show_combat_mode()
			get_tree().paused = false
	else:
		_hide_combat_mode()
		show_inventory()
		get_tree().paused = true
		
func show_inventory():
	PDS.clear_target()
	inventory_ui.show()
	
func close_inventory():
	inventory_ui.hide()

func show_charadoll():
	PDS.clear_target()
	charadoll_ui.show()
	
func hide_charadoll():
	charadoll_ui.hide()
	
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
		
func add_to_inventory(object: PickableObject):
	var dm = DialogMessage.new()
	var r = $PlayerInventory.add_to_inventory(object)
	if r == 1:
		dm.message = "Your inventory is full !"
		DS.spawn_dialog("", null, dm)
	if r == 2:
		dm.message = "This is too heavy ! It weighs " + String(object.get_weight()) + " Stones"
		DS.spawn_dialog("", null, dm)			
	