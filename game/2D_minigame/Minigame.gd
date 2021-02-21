extends Node2D


onready var label :Object = $Label
onready var progress_bar :Object = $VBoxContainer/ProgressBar
onready var arrow :Object = $Arrow
onready var buffer_timer :Object = $Timer
onready var anim :Object = $AnimationPlayer
onready var sound_correct :Object = $Sound_Correct
onready var sound_wrong :Object = $Sound_Wrong
var possible_inputs :Array = ["Up", "Left", "Down", "Right"]
var correct_answer :String
var score :int = 0
export var max_score :int = 200
var running :bool = false
var is_turned_on :bool = false

func turn_on():
	anim.play("start")
	is_turned_on = true

func _ready() -> void:
	new_answer()
	progress_bar.max_value = max_score

# warning-ignore:unused_argument
func _process(delta) -> void:
	arrow.rect_scale = Vector2((Global.player.bpm / 100.0), (Global.player.bpm / 100.0))
	label.rect_scale = Vector2((Global.player.bpm / 100.0), (Global.player.bpm / 100.0))

# warning-ignore:unused_argument
func _input(event) -> void:
	if running && !anim.is_playing():
		if Input.is_action_just_pressed("ui_up"):
			check_answer("Up")
		if Input.is_action_just_pressed("ui_down"):
			check_answer("Down")
		if Input.is_action_just_pressed("ui_left"):
			check_answer("Left")
		if Input.is_action_just_pressed("ui_right"):
			check_answer("Right")
		Global.player.bpm -= 1


func check_answer(input) -> void:
	if input == correct_answer:
		anim.play("right")
		sound_correct.play()
		score += 1
		progress_bar.value = score
		if score >= max_score:
			win()
		else:
			new_answer()
	else:
		anim.play("wrong")
		sound_wrong.play()
		score -= 1
		progress_bar.value = score


func new_answer() -> void:
	randomize()
	possible_inputs.shuffle()
	correct_answer = possible_inputs.front()
	label.text = correct_answer
	update_arrow(correct_answer)


func update_arrow(answer):
	if answer == "Up":
		arrow.rect_rotation = 0.0
	elif answer == "Down":
		arrow.rect_rotation = 180.0
	elif answer == "Left":
		arrow.rect_rotation = -90.0
	elif answer == "Right":
		arrow.rect_rotation = 90.0


func win() -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene_to(load("res://Menu/Win_screen.tscn"))
