extends Popup
class_name DialogPanel

signal on_dialog_end

var _messages := []
var _current_index := 0

func _ready():
	set_process(false)

func _process(delta):
	if Input.is_action_just_pressed("mouse_left_click"):
		if _current_index < _messages.size() - 1:
			_current_index += 1
			$Panel/CharaMessage.text = _messages[_current_index]
		else: 
			get_tree().paused = false
			self.hide()

func my_popup(chara_name: String, chara_portrait: Texture, messages: Array):
	
	$"../".layer = 255
	assert(messages.size() > 0)

	$Panel/CharaName.text = chara_name
	$Panel/CharaPortrait.texture = chara_portrait
	_messages = messages
	_current_index = 0
	$Panel/CharaMessage.text = _messages[_current_index]
	
	get_tree().paused = true
	set_process(true)
	.popup()

func hide():
	$"../".layer = 0
	set_process(false)
	emit_signal("on_dialog_end")
	.hide()
	