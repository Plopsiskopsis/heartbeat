extends KinematicBody

onready var cam :Object = $head/Camera
var camera_angle :float = 0.0 
var mouse_sensitivity :float = 0.3

var velocity :Vector3 = Vector3()
var direction :Vector3 = Vector3()
var gravity :float = -9.8 * 3
var es_drinks : int = 3
var bpm :float = 100.0
var bpm_offset :float = 1.0

const BPM_OFFSET_MULTIPLIER = 2.0

const MAX_SPEED :float = 20.0
const MAX_RUNNING_SPEED :float = 30.0
const ACCEL :float = 2.0
const DEACCEL :float = 6.0

export var jump_height :float = 5.0
var on_computer :bool = false

func _ready() -> void:
	$UI.es_count(es_drinks)
	Global.player = self
	$UI.heartbeat()
	$heart_timer.wait_time = 60.0 / bpm

func _physics_process(delta) -> void:
	bpm_offset = bpm / 100.0
	MusicPlayer.set_pitch_scale(bpm_offset)
	if bpm_offset > 1.0:
		bpm_offset *= BPM_OFFSET_MULTIPLIER
	else:
		bpm_offset /= BPM_OFFSET_MULTIPLIER
	if !on_computer:
		walk(delta)

func _process(delta):
	var material_bpm = ((bpm -100.0) / 100.0) * 2.0
	$Spookies.material.set_shader_param("strength", material_bpm)
	$Spookies.material.set_shader_param("pump_up", material_bpm)
	bpm -= delta
	if bpm < 50.0 or bpm > 200.0:
# warning-ignore:return_value_discarded
		get_tree().change_scene_to(load("res://Menu/Lose_screen.tscn"))

func set_cam() -> void:
	cam.current = true
	check_drinks()

func check_drinks() -> void:
	if es_drinks < 0:
		$head/Camera/es.visible = false

func _input(event) -> void:
	if Input.is_action_just_pressed("drink") && !$AnimationPlayer.is_playing():
		if es_drinks > 0:
			es_drinks -= 1
			$UI.es_count(es_drinks)
			$UI.drink()
			$AnimationPlayer.play("drink")
			bpm += 20
			$heart_timer.wait_time = 60.0 / bpm
	
	if !on_computer:
		if event is InputEventMouseMotion:
			rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
			var change :float = -event.relative.y * mouse_sensitivity  * bpm_offset
			if change + camera_angle < 90 and change + camera_angle > -90:
				cam.rotate_x(deg2rad(change))
				camera_angle += change
		
		if Input.is_action_just_pressed("action"):
			var ray_length :float = 100.0
			var pos = get_viewport().get_mouse_position()
			if pos:
				var from :Vector3 = cam.project_ray_origin(pos)
				var to :Vector3 = from + cam.project_ray_normal(pos) * ray_length
				var space_state :PhysicsDirectSpaceState = get_world().get_direct_space_state()
				if space_state:
					var result :Dictionary = space_state.intersect_ray( from, to, [self], 0x7FFFFFFF, true, true)
					if result:
						if result.collider.is_in_group("action"):
							result.collider.get_parent().action() 
							if result.collider.is_in_group("es"):
								$UI.es_count(es_drinks)
								if es_drinks > 0:
									$head/Camera/es.visible = true
						


func walk(delta) -> void:
	direction = Vector3() 
	var aim :Basis = cam.get_global_transform().basis
	if Input.is_action_pressed("move_forward"):
		direction -= aim.z
	if Input.is_action_pressed("move_backward"):
		direction += aim.z
	if Input.is_action_pressed("move_left"):
		direction -= aim.x
	if Input.is_action_pressed("move_right"):
		direction += aim.x
	direction = direction.normalized() #ettei mennÃ¤ turhan lujaa
	velocity.y += gravity * delta
	var temp_velocity :Vector3 = velocity 
	temp_velocity.y = 0 
	var speed :float
	if Input.is_action_pressed("move_sprint"):
		speed = MAX_RUNNING_SPEED
	else:
		speed = MAX_SPEED
	var target :Vector3 = direction * speed
	var acceleration :float
	if direction.dot(temp_velocity) > 0:
		acceleration = ACCEL
	else:
		acceleration = DEACCEL
	temp_velocity = temp_velocity.linear_interpolate(target,acceleration * delta)
	velocity.x = temp_velocity.x
	velocity.z = temp_velocity.z
	velocity = move_and_slide(velocity,Vector3(0,1,0) * bpm_offset)
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_height * bpm_offset


func _on_heart_timer_timeout() -> void:
	$UI.heartbeat()
