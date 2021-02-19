extends Spatial

var can_start :bool = false
var comp_started :bool = false

# warning-ignore:unused_argument
func _input(event):
	if comp_started && Input.is_action_just_pressed("leave_comp"):
		if $Timer.time_left > 0.0:
			return
		Global.player.set_cam()
		Global.player.on_computer = false
		comp_started = false
		$Comp_screen/Viewport/Minigame.running = false

func _on_Area_body_entered(body) -> void:
	if body == Global.player:
		can_start = true

func _on_Area_body_exited(body) -> void:
	if body == Global.player:
		can_start = false

func action() -> void:
	if $Timer.time_left > 0.0:
		return
	if can_start && !comp_started:
		get_parent().get_node("Comp_cam_pos").current = true
		comp_started = true
		Global.player.on_computer = true
		$Comp_screen/Viewport/Minigame.running = true
		if not $Comp_screen/Viewport/Minigame.is_turned_on:
			$Comp_screen/Viewport/Minigame.turn_on()
	else:
		print("too far")
