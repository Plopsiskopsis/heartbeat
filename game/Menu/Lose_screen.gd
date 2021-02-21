extends Control

onready var reason_label: Object = $CenterContainer/VBoxContainer/Reason_For_Dying

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	match Global.death_reason:
		"Too much":
			reason_label.text = "Jonne had too much ES and had a heart attack!"
		"Too little":
			reason_label.text = "Jonne had too little ES and fell asleep!"

func _on_TextureButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene_to(load("res://Menu/Menu.tscn"))
