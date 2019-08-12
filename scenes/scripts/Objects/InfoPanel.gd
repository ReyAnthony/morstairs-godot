extends TextureRect
class_name InventoryInfoPanel

func _ready():
	mouse_filter = MOUSE_FILTER_STOP ##SO THAT WE can't drop stuff

func reset():
	$ObjectName.text = "Hover on an object"
	$ObjectWeight.text = "to get more infos"
	
func update_panel(name: String, weight: int):
	$ObjectName.text = name
	$ObjectWeight.text = "It weighs " + String(weight) + " Stones"
	
func _process(delta):
	$Weight.text = "Weight : " + String($"../Bag".get_weight()) + "/" + String($"../Bag".get_max_weight())	