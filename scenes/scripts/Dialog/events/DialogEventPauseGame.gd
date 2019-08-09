extends DialogEvent
class_name DialogEventPauseGame

func execute():
	get_tree().paused = true