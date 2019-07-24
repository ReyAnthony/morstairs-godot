extends Popup

signal on_dialog_end

var messages = []
var current_index = 0

func _ready():
	set_process(false)

func _process(delta):
	if Input.is_action_just_pressed("mouse_left_click"):
		if current_index < messages.size() - 1:
			current_index += 1
			$Panel/CharaMessage.text = messages[current_index]
		else: 
			get_tree().paused = false
			self.hide()

func my_popup(chara_name, chara_portrait, messages):
	
	assert(messages.size() > 0)

	$Panel/CharaName.text = chara_name
	$Panel/CharaPortrait.texture = chara_portrait
	self.messages = messages
	current_index = 0
	$Panel/CharaMessage.text = messages[current_index]
	
	get_tree().paused = true
	set_process(true)
	.popup()

func hide():
	set_process(false)
	emit_signal("on_dialog_end")
	.hide()
	