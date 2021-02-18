extends Spatial

onready var es_scn :PackedScene = load("res://3D_level/objektit/es.tscn")

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	spawn_es()


func spawn_es() -> void:
	var spot :int = randi() % $House/House_ES_Spawpoints.get_child_count()
	var pos :Vector3 = $House/House_ES_Spawpoints.get_child(spot).translation
	var es :Object = es_scn.instance()
	es.translation = pos
	add_child(es)
