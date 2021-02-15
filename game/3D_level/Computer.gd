extends Spatial

var can_start :bool = false

func _on_Area_body_entered(body) -> void:
	if body == Global.player:
		can_start = true

func _on_Area_body_exited(body) -> void:
	if body == Global.player:
		can_start = false

func action() -> void:
	if can_start:
		get_tree().change_scene_to(load("res://2D_minigame/Minigame.tscn"))
	else:
		print("no start")
