extends Node2D


onready var label = $Label
onready var progress_bar = $ProgressBar
onready var buffer_timer = $Timer
var possible_inputs = ["Up", "Left", "Down", "Right"]
var correct_answer
var score = 0
export var max_score = 20


func _ready():
	new_answer()
	progress_bar.max_value = max_score


func _unhandled_key_input(event):
	if Input.is_action_just_pressed("ui_up"):
		check_answer("Up")
	if Input.is_action_just_pressed("ui_down"):
		check_answer("Down")
	if Input.is_action_just_pressed("ui_left"):
		check_answer("Left")
	if Input.is_action_just_pressed("ui_right"):
		check_answer("Right")


func check_answer(input):
	if input == correct_answer:
		answer_was_correct()
	else:
		print("Väärin!")
		score -= 1
		progress_bar.value = score

func answer_was_correct():
	print("Oikein!")
	score += 1
	progress_bar.value = score
	if score >= max_score:
		win()
	else:
		new_answer()


func new_answer():
	randomize()
	possible_inputs.shuffle()
	correct_answer = possible_inputs.front()
	label.text = correct_answer


func win():
	#TODO: tähä sit jotai lol
	print("Voitit pelin!")
