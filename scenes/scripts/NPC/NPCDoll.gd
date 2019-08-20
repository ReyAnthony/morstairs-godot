extends Doll
class_name NPCDoll

func get_equipement() -> Array:
	var l = []
	for slot in $Doll.get_children():
		slot = slot as Slot
		if !slot.is_empty():
			l.append(slot.get_object_in_slot())
	return l