extends Node2D


onready var label :Object = $Label
onready var progress_bar :Object = $ProgressBar
onready var buffer_timer :Object = $Timer
var possible_inputs :Array = ["Up", "Left", "Down", "Right"]
var correct_answer :String
var score :int = 0
export var max_score :int = 20


func _ready() -> void:
	new_answer()
	progress_bar.max_value = max_score


# warning-ignore:unused_argument
func _input(event) -> void:
	if Input.is_action_just_pressed("ui_up"):
		check_answer("Up")
	if Input.is_action_just_pressed("ui_down"):
		check_answer("Down")
	if Input.is_action_just_pressed("ui_left"):
		check_answer("Left")
	if Input.is_action_just_pressed("ui_right"):
		check_answer("Right")


func check_answer(input) -> void:
	if input == correct_answer:
		answer_was_correct()
	else:
		print("Väärin!")
		score -= 1
		progress_bar.value = score

func answer_was_correct() -> void:
	print("Oikein!")
	score += 1
	progress_bar.value = score
	if score >= max_score:
		win()
	else:
		new_answer()


func new_answer() -> void:
	randomize()
	possible_inputs.shuffle()
	correct_answer = possible_inputs.front()
	label.text = correct_answer


func win() -> void:
	#TODO: tähä sit jotai lol
	print("Voitit pelin!")
