extends Node
class_name DialogMessage

export (String, MULTILINE) var message: String
export (bool) var is_choice: bool = false
export (bool) var is_player: bool = false
export (NodePath) var dialog_event_path: NodePath

var _dialog_event: DialogEvent
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
	
	if !dialog_event_path.is_empty():
		_dialog_event = get_node(dialog_event_path)

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
	
func execute_event():
	assert(has_event())
	_dialog_event.execute()
	
func has_event() -> bool:
	return _dialog_event != null
			
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