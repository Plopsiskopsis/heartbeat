extends KinematicBody

onready var cam :Object = $head/Camera
var camera_angle :float = 0.0 
var mouse_sensitivity :float = 0.3

var velocity :Vector3 = Vector3()
var direction :Vector3 = Vector3()
var asekohta :Vector3 = Vector3(0,0.3,-0.7)
var gravity :float = -9.8 * 3
var flying :bool = false

const MAX_SPEED :float = 20.0
const MAX_RUNNING_SPEED :float = 30.0
const ACCEL :float = 2.0
const DEACCEL :float = 6.0

const FLY_SPEED :float = 20.0
const FLY_ACCEL :float = 2.0

var jump_height :float = 15.0

func _ready():
	Global.player = self

func _physics_process(delta) -> void:
	if flying:
		fly(delta)
	else:
		walk(delta)
	

func _input(event) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		var change :float = -event.relative.y * mouse_sensitivity
		if change + camera_angle < 90 and change + camera_angle > -90:
			cam.rotate_x(deg2rad(change))
			camera_angle += change
	if Input.is_action_just_pressed("ui_focus_next"):
		flying = !flying
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
	velocity = move_and_slide(velocity,Vector3(0,1,0))
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_height

func fly(delta) -> void:
	direction = Vector3()
	var aim :Basis = $head/Camera.get_global_transform().basis
	if Input.is_action_pressed("move_forward"):
		direction -= aim.z
	if Input.is_action_pressed("move_backward"):
		direction += aim.z
	if Input.is_action_pressed("move_left"):
		direction -= aim.x
	if Input.is_action_pressed("move_right"):
		direction += aim.x
	direction = direction.normalized() 
	var target :Vector3 = direction * FLY_SPEED
	velocity = velocity.linear_interpolate(target,FLY_ACCEL * delta)
# warning-ignore:return_value_discarded
	move_and_slide(velocity)

