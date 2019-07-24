extends Node2D

var life = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func hit(): 
	life -= 3;
		
