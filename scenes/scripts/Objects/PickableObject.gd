extends GameObjectBase
class_name PickableObject

const ObjectType = preload("res://scenes/scripts/Objects/ObjectType.gd").ObjectType

export (ObjectType) var type: int
export (int) var weight: int
export (String) var _name: String

func _ready():
	$Interactable/Name.text = _name

func _on_Interactable_something_is_inside_interactable(body: PhysicsBody2D):
	if PDS.get_target().is_you(self):
		PDS.add_to_inventory(self)
		PDS.clear_target()
		
func get_weight() -> int:
	return weight		
	
func get_object_name() -> String:
	return _name	
	
func get_type() -> int:
	return type	