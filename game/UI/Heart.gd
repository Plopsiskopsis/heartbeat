extends Node2D

onready var anim :Object = $AnimationPlayer

func beat() -> void:
	anim.play("beat")
