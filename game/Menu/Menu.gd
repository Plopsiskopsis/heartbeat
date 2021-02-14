extends Control

func _ready() -> void:
	randomize() # for getting random seed in game

func _on_Start_button_pressed() -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene_to(load("res://3D_level/3D_level.tscn"))


func _on_Music_button_pressed() -> void:
	MusicPlayer.playing = !MusicPlayer.playing


func _on_Quit_button_pressed() -> void:
	get_tree().quit()
