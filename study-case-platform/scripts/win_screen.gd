extends Node2D

func _process(_delta):
	if Input.is_action_just_pressed("confirm"):
		get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
	
