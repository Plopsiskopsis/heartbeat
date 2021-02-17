extends Control

func heartbeat() -> void:
	$Heart.beat()
	$Heart/Label.text = str(Global.player.bpm) 
