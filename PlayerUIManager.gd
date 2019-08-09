extends CanvasLayer

var charadoll_button
var charadoll_ui
var inventory_button
var inventory_ui

func _ready():
	pause_mode = PAUSE_MODE_PROCESS
	charadoll_button = $Panel/Player/Portrait
	charadoll_ui = $PlayerInventory/CharaDoll
	charadoll_button.connect("pressed", self, "_on_charadoll_pressed")
	
	inventory_button = $Panel/Inventory
	inventory_ui = $PlayerInventory
	inventory_button.connect("pressed", self, "_on_inventory_pressed")

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