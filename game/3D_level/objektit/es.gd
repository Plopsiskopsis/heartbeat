extends Spatial

var can_grab :bool = false
export var for_anim = false

func _on_Area_body_entered(body) -> void:
	if body == Global.player:
		can_grab = true

func _on_Area_body_exited(body) -> void:
	if body == Global.player:
		can_grab = false

func action() -> void:
	if can_grab && !for_anim:
		Global.player.es_drinks += 1
		can_grab = false
		queue_free()
