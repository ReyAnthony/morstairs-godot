extends Node
class_name Doll

func _ready():
	assert($Doll)
	assert($Doll/WeaponSlot)
	assert($Doll/ArmorSlot)
	assert($Doll/ShieldSlot)
	assert($Doll/BootsSlot)
	assert($Doll/HelmetSlot)

func _get_equipped_weapon() -> PickableObject:
	assert(!$Doll/WeaponSlot.is_empty())
	return $Doll/WeaponSlot.get_object_in_slot()
		
func _get_equipped_armor() -> PickableObject:
	assert(!$Doll/ArmorSlot.is_empty())
	return $Doll/ArmorSlot.get_object_in_slot()

func _get_equipped_shield() -> PickableObject:
	assert(!$Doll/ShieldSlot.is_empty())
	return $Doll/ShieldSlot.get_object_in_slot()
	
func _get_equipped_boots() -> PickableObject:
	assert(!$Doll/BootsSlot.is_empty())
	return $Doll/BootsSlot.get_object_in_slot()	
	
func _get_equipped_helmet() -> PickableObject:
	assert(!$Doll/HelmetSlot.is_empty())
	return $Doll/HelmetSlot.get_object_in_slot()

func _get_default_damages() -> int:
	if $Doll/WeaponSlot.is_empty():
		return 1
	else:
		return _get_equipped_weapon().get_damages()

func get_damages(defender: Doll) -> int: 
	return int(max(_get_default_damages() - defender.get_defense(), 0))

func get_defense() -> int:
	var def = 0
	if !$Doll/ArmorSlot.is_empty():
		def += _get_equipped_armor().get_defense()
	if !$Doll/ShieldSlot.is_empty():
	    def += _get_equipped_shield().get_defense()
	if !$Doll/BootsSlot.is_empty():
	    def += _get_equipped_boots().get_defense()
	if !$Doll/HelmetSlot.is_empty():
	    def += _get_equipped_helmet().get_defense()
	return def	