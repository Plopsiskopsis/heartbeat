extends Node2D


onready var label = $Label
onready var progress_bar = $ProgressBar
onready var buffer_timer = $Timer
var possible_inputs = ["W", "A", "S", "D"]
var correct_answer
var score = 0
export var max_score = 20


func _ready():
	new_answer()
	progress_bar.max_value = max_score


func _input(event):
	if event is InputEventKey:
		print(event.as_text())
		if event.as_text() == correct_answer:
			correct_answer()
			yield(buffer_timer,"timeout")
		else:
			print("Väärin!")
			score -= 1
			buffer_timer.start()
			yield(buffer_timer,"timeout")


func correct_answer():
	print("Oikein!")
	score += 1
	progress_bar.value = score
	if score >= max_score:
		win()
	else:
		new_answer()
		buffer_timer.start()


func new_answer():
	randomize()
	possible_inputs.shuffle()
	correct_answer = possible_inputs.front()
	label.text = correct_answer


func win():
	#TODO: tähä sit jotai lol
	print("Voitit pelin!")
