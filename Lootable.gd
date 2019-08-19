extends GameObjectBase
class_name Lootable

func _ready():
	$Content.hide()

func _on_Interactable_something_is_inside_interactable(body: PhysicsBody2D):
	if body.is_in_group("player") and PDS.get_target().is_you(self):
		PDS.clear_target()
		PDS.get_player_ui_manager().show_inventory_and_loot($Content.get_children(), $Content)
