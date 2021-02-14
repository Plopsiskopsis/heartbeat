extends Node2D

onready var anim = $AnimationPlayer

func beat() -> void:
	anim.play("beat")
