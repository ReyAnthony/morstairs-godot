extends TextureRect
class_name InventoryInfoPanel

func _ready():
	mouse_filter = MOUSE_FILTER_STOP ##SO THAT WE can't drop stuff

func reset():
	$ObjectName.text = "Hover on an object"
	$ObjectWeight.text = "to get more infos"
	$ObjectDesc.text = ""
	$ObjectSpecificationDesc.text = ""
	
func update_panel(object: PickableObject):
	if object.is_stackable():
		$ObjectName.text = object.get_object_name() + " (" + String(object.get_stack_count()) + ")"
	else:
		$ObjectName.text = object.get_object_name() 
	$ObjectWeight.text = "It weighs " + String(object.get_weight()) + " Stones"
	$ObjectDesc.text = object.get_desc()
	$ObjectSpecificationDesc.text = object.get_specification_desc()
	
func _process(delta):
	$Weight.text = "Weight : " + String($"../../PlayerInventory".get_total_weight()) + "/" + String($"../../PlayerInventory".get_max_weight())	