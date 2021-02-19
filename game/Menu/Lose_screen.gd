extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_TextureButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene_to(load("res://Menu/Menu.tscn"))
