extends Node2D

export (float) var CYCLE_LENGTH_DAY_IN_SEC
export (float) var CYCLE_LENGTH_NIGHT_DIV

var CYCLE_LENGTH_NIGHT
var day = true
var anim_node
var time

func _ready():
	time = 0
	anim_node = $AnimationPlayer
	CYCLE_LENGTH_NIGHT = CYCLE_LENGTH_DAY_IN_SEC / CYCLE_LENGTH_NIGHT_DIV
	self.set_process(true)
   
func _process(delta):
	if time < get_cycle_length() && !anim_node.is_playing():
		time += delta
	elif time >= get_cycle_length(): 
		if day:
			day_end()
		else:
			night_end()
		day = !day
		time = 0

func get_cycle_length():
	if day: 
		return CYCLE_LENGTH_DAY_IN_SEC 
	else:
		return  CYCLE_LENGTH_NIGHT		
		
func day_end():
	anim_node.play("Daylight_cycle")
	for t in get_tree().get_nodes_in_group("torchs"):
		t.light_it()
	
func night_end():
	anim_node.play_backwards("Daylight_cycle")	
	for t in get_tree().get_nodes_in_group("torchs"):
		t.unlight_it()