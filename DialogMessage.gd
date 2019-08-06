extends Node
class_name DialogMessage

export (String, MULTILINE) var message: String
export (bool) var is_choice: bool = false
export (bool) var is_player: bool = false

var _next: DialogMessage


func _ready():
	assert(get_child_count() <= 4)
	for c in get_children():
		if c.get_class() != get_class():
			assert(false)
		if !c.is_choice() and get_child_count() > 1:
			assert(false)
	
	if(is_choice()):
		is_player = true

func get_next() -> DialogMessage:
	if (has_choices()):
		assert(_next != null)
		return _next
	return get_children()[0]
	
func has_next() -> bool:
	return get_child_count() != 0
	
func override_next(message: DialogMessage):
	assert(has_choices())
	_next = message
	
func is_choice() -> bool: 
	return 	is_choice
	
func has_choices() -> bool:
	return get_child_count() > 1

func choices() -> Array:
	assert(has_choices())
	return get_children()

func get_class() -> String:
	#workaround because you can't IS yourself because of cyclic ref
	return "DialogMessage"