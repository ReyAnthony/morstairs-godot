extends Node2D

export (NodePath) var source_path
#export (NodePath) var player_path
#export (NodePath) var target_path

func _ready():
	pass

func _on_Room_body_entered(body):
	if body.is_in_group("player"):
		print("enter")
		#var player = get_node(player_path)
		var source = get_node(source_path)
		#var target = get_node(target_path)
		source.modulate = Color(0.2, 0.2, 0.2)
		#target

func _on_Room_body_exited(body):
	if body.is_in_group("player"):
		print("enter")
		#var player = get_node(player_path)
		var source = get_node(source_path)
		#var target = get_node(target_path)
		source.modulate = Color(1,1,1)
		