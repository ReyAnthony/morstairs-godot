extends Control
class_name Dice

var rng: RandomNumberGenerator

func _ready():
	rng = RandomNumberGenerator.new()

func _dice_throw(d: int = 1, faces: int = 6) -> Array:
	assert(d > 0)
	assert(faces > 1)
	var throws:Array = []
	for i in range(0, d):
		throws.append(rng.randi_range(1, faces))
	return throws
	
