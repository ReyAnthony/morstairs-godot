extends Node2D
class_name DayNight

export (float) var _CYCLE_LENGTH_DAY_IN_SEC: float
export (float) var _CYCLE_LENGTH_NIGHT_DIV: float

var _CYCLE_LENGTH_NIGHT: float
var _day: bool = true
var _time: float
var _anim_node: AnimationPlayer

func _ready():
	assert(_CYCLE_LENGTH_DAY_IN_SEC > 0)
	assert(_CYCLE_LENGTH_NIGHT_DIV > 0)
	_time = 0
	_anim_node = $AnimationPlayer
	_CYCLE_LENGTH_NIGHT = _CYCLE_LENGTH_DAY_IN_SEC / _CYCLE_LENGTH_NIGHT_DIV
	self.set_process(true)
   
func _process(delta):
	if _time < _get_cycle_length() && !_anim_node.is_playing():
		_time += delta
	elif _time >= _get_cycle_length(): 
		if _day:
			_day_end()
		else:
			_night_end()
		_day = !_day
		_time = 0

func _get_cycle_length():
	if _day: 
		return _CYCLE_LENGTH_DAY_IN_SEC 
	else:
		return  _CYCLE_LENGTH_NIGHT
		
func _day_end():
	_anim_node.play("Daylight_cycle")
	for t in get_tree().get_nodes_in_group("torchs"):
		var tt: Torch = t as Torch
		tt.light_it()
	
func _night_end():
	_anim_node.play_backwards("Daylight_cycle")	
	for t in get_tree().get_nodes_in_group("torchs"):
		var tt: Torch = t as Torch
		tt.unlight_it()