extends KinematicBody2D
class_name GameObjectBase

export (Material) var material_on_mouse_enter: Material
export (Material) var material_on_target: Material

var can_be_hit := false

func _ready():
	assert($Interactable != null)
	$Interactable.connect("mouse_clicked", self, "_on_Interactable_mouse_clicked")
	$Interactable.connect("mouse_entered", self,  "_on_Interactable_mouse_entered")
	$Interactable.connect("mouse_exited", self, "_on_Interactable_mouse_exited")
	$Interactable.connect("something_is_inside_interactable", self, "_on_Interactable_something_is_inside_interactable")

func _on_Interactable_mouse_clicked():
	PDS.set_target(global_position, self)

func _on_Interactable_mouse_entered():
	if !PDS.get_target().is_you(self):
		$Sprite.material = material_on_mouse_enter

func _on_Interactable_mouse_exited():
	if $Sprite.material == material_on_mouse_enter:
		$Sprite.material = null
		
func _on_Interactable_something_is_inside_interactable(body: PhysicsBody2D):
	pass		