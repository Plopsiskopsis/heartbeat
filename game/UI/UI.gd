extends Control

func es_count(count):
	$ui_es/Label.text = str(count)

func heartbeat() -> void:
	$Heart.beat()
	$Heart/Label.text = str(Global.player.bpm) 
