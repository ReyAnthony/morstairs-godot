extends PathFollow2D

func _ready():
	set_process(true)
	pass

func _process(delta):
	self.offset += 15 * delta
