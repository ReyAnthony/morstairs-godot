extends GameObjectBase
class_name PickableObject

const ObjectType = preload("res://scenes/scripts/Objects/ObjectType.gd").ObjectType

export (ObjectType) var type: int
export (int) var weight: int
export (int) var contextual_value: int ##attack/def etc..
export (String) var _name: String
export (String) var _description: String

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

func get_desc() -> String:
	return _description

func get_damages() -> int:
	##TODO range like 1 to 5
	assert(type == ObjectType.WEAPON)
	return contextual_value

func get_defense() -> int:
	##TODO range like 1 to 5
	assert(type == ObjectType.ARMOR)
	return contextual_value	

func get_specification_desc() -> String:
	if type == ObjectType.WEAPON:
		return "It gives " + String(get_damages()) + " damages to an unarmored target."
	elif type == ObjectType.ARMOR:
		return "It gives " + String(get_defense()) + " defense points."
	else:
		assert(false)
		return ""