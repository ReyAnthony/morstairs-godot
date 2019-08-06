extends Node
class_name DialogMessage

export (String, MULTILINE) var message: String

func _ready():
	assert(get_child_count() <= 4)
	var type :String
	for c in get_children():
		var t = c.get_class()
		if t == "DialogMessage" and get_children().size() > 1:
			assert(false)
		if t != type and type != "":
			assert(false)
		type = t

func get_next() -> DialogMessage:
	return get_children()[0]
	
func has_next() -> bool:
	return get_child_count() != 0
	
func has_choice() -> bool:
	return false

func choices() -> Array:
	return []
	