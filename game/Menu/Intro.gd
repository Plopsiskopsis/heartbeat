extends Control



func _on_TextureButton_pressed():
	get_tree().change_scene_to(load("res://Menu/Menu.tscn"))
