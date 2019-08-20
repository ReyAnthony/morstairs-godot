extends Node
class_name Doll

func _ready():
	assert($Doll)
	assert($Doll/WeaponSlot)
	assert($Doll/ArmorSlot)

func _get_equipped_weapon() -> PickableObject:
	assert(!$Doll/WeaponSlot.is_empty())
	return $Doll/WeaponSlot.get_object_in_slot()
		
func _get_equipped_armor() -> PickableObject:
	assert(!$Doll/ArmorSlot.is_empty())
	return $Doll/ArmorSlot.get_object_in_slot()
	
func _get_default_damages() -> int:
	if $Doll/WeaponSlot.is_empty():
		return 1
	else:
		return _get_equipped_weapon().get_damages()

func get_damages(defender: Doll) -> int: 
	return int(max(_get_default_damages() - defender.get_defense(), 0))

func get_defense() -> int:
	if $Doll/ArmorSlot.is_empty():
		return 0
	return _get_equipped_armor().get_defense()