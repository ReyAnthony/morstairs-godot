extends Popup
class_name DialogPanel

signal on_dialog_end

var _messages :DialogMessage

func _ready():
	set_process(false)

func _process(delta):
	if Input.is_action_just_pressed("mouse_left_click"):
		if _messages.has_next():
			_messages = _messages.get_next()
			$Panel/CharaMessage.text = _messages.message
		else: 
			get_tree().paused = false
			$"../".layer = 0
			set_process(false)
			emit_signal("on_dialog_end")
			hide()

func my_popup(chara_name: String, chara_portrait: Texture, messages: DialogMessage):
	
	$"../".layer = 255

	$Panel/CharaName.text = chara_name
	$Panel/CharaPortrait.texture = chara_portrait
	_messages = messages
	$Panel/CharaMessage.text = _messages.message
	
	get_tree().paused = true
	set_process(true)
	.popup()