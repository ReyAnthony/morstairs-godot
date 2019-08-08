extends Popup
class_name DialogPanel

signal on_dialog_end

var _messages :DialogMessage
var _chara_name :String
var _chara_portrait: Texture
var lock = false

func _ready():
	set_process(false)
	var i = 0
	for c in $Panel/Center/Grid/Panel/Choices.get_children():
		c.connect("pressed", self, "_on_choice_clicked_" + String(i))
		i += 1

func _process(delta):
	if Input.is_action_just_pressed("mouse_left_click") and !_messages.has_choices():
		_advance_dialog()

func my_popup(chara_name: String, chara_portrait: Texture, messages: DialogMessage):
	
	get_tree().paused = true
	$"../".layer = 255

	_chara_name = chara_name
	_chara_portrait = chara_portrait
	_messages = messages
	_update_text()
	
	set_process(true)
	.popup()

func _advance_dialog():
	
	if _messages.has_next():
		if _messages.has_event():
			_messages.execute_event()
		_messages = _messages.get_next()
		_update_text()
		return
	else: 
		get_tree().paused = false
		$"../".layer = 0
		set_process(false)
		emit_signal("on_dialog_end")
		hide()
		if _messages.has_event():
			_messages.execute_event()

func _update_text():
	$Panel/Center/Grid/Panel/CharaMessage.text = _messages.message
	for c in $Panel/Center/Grid/Panel/Choices.get_children():
		c.hide()
		
	$Panel/Center/Grid/Portrait.show()
	
	if _messages.is_player:
		$Panel/Center/Grid/Portrait/CharaName.text = PDS.get_player_name()
		$Panel/Center/Grid/Portrait/CharaPortrait.texture = PDS.player_portrait
	elif _messages.is_narrator:
		$Panel/Center/Grid/Portrait.hide()
	else:
		$Panel/Center/Grid/Portrait/CharaName.text = _chara_name
		$Panel/Center/Grid/Portrait/CharaPortrait.texture = _chara_portrait
		if _chara_portrait == null:
			$Panel/Center/Grid/Portrait.hide()
	
	if _messages.has_choices():
		var i = 0
		for c in _messages.choices():
			c = c as DialogMessage
			var b: Button = $Panel/Center/Grid/Panel/Choices.get_children()[i]
			b = (b as Button)
			b.text = c.message
			b.show()
			i += 1
			
func _on_choice_clicked_0():
	_messages = _messages.choices()[0]
	_advance_dialog()
	
func _on_choice_clicked_1():
	_messages = _messages.choices()[1]
	_advance_dialog()
	
func _on_choice_clicked_2():
	_messages = _messages.choices()[2]
	_advance_dialog()

func _on_choice_clicked_3():
	_messages = _messages.choices()[3]
	_advance_dialog()