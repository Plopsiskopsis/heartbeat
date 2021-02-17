extends Control

func es_count(count) -> void:
	$ui_es/Label.text = str(count)

func heartbeat() -> void:
	$Heart.beat()
	$Heart/Label.text = str(Global.player.bpm) 

func drink() -> void:
	$Heart/Particles2D.emitting = true
