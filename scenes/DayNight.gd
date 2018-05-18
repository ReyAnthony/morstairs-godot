extends Node2D

export (NodePath) var anim
var time
var CYCLE_LENGTH_DAY_IN_SEC = 20
var CYCLE_LENGTH_NIGHT = CYCLE_LENGTH_DAY_IN_SEC / 4
var day = true
var anim_node

func _ready():
	time = 0
	anim_node = get_node(anim)
	self.set_process(true)
   
func _process(delta):
	if time < get_cycle_length() && !anim_node.is_playing():
		time += delta
	elif time >= get_cycle_length(): 
		if day:
			day()
		else:
			night()
		day = !day
		time = 0

func get_cycle_length():
	if day: 
		return CYCLE_LENGTH_DAY_IN_SEC 
	else:
		return  CYCLE_LENGTH_NIGHT		
		
func day():
	get_node(anim).play("Daylight_cycle")
	for t in get_tree().get_nodes_in_group("torchs"):
		t.light_it()
	
func night():
	get_node(anim).play_backwards("Daylight_cycle")	
	for t in get_tree().get_nodes_in_group("torchs"):
		t.unlight_it()