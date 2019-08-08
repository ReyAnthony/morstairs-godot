extends GameObjectBase
class_name PickableObject

export (int) var weight 

func _on_Interactable_something_is_inside_interactable(body: PhysicsBody2D):
	if PDS.get_target().is_you(self):
		PDS.add_to_inventory(self)
		PDS.clear_target()
		
func get_weight() -> int:
	return weight		