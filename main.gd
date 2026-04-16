extends Control

var count := 0
var time_left := 10
var game_active := false
var target_score := 15

var rng := RandomNumberGenerator.new()

@onready var status_label = $CenterContainer/VBoxContainer/StatusLabel
@onready var result_label = $CenterContainer/VBoxContainer/ResultLabel
@onready var target_label = $CenterContainer/VBoxContainer/TargetLabel
@onready var counter_label = $CenterContainer/VBoxContainer/CounterLabel
@onready var time_label = $CenterContainer/VBoxContainer/TimeLabel
@onready var start_button = $CenterContainer/VBoxContainer/StartButton
@onready var increase_button = $CenterContainer/VBoxContainer/IncreaseButton
@onready var reset_button = $CenterContainer/VBoxContainer/ResetButton
@onready var game_timer = $CenterContainer/VBoxContainer/GameTimer

func _ready():
	rng.randomize()
	prepare_new_round()

func prepare_new_round():
	target_score = rng.randi_range(12, 20)
	count = 0
	time_left = 10
	game_active = false

	status_label.text = "Hazır"
	result_label.text = ""
	start_button.disabled = false
	increase_button.disabled = true
	reset_button.disabled = false

	game_timer.stop()
	update_ui()

func update_ui():
	target_label.text = "Hedef: %d" % target_score
	counter_label.text = "Skor: %d" % count
	time_label.text = "Süre: %d" % time_left

func _on_start_button_pressed():
	count = 0
	time_left = 10
	game_active = true

	status_label.text = "Oyun başladı!"
	result_label.text = ""
	start_button.disabled = true
	increase_button.disabled = false

	update_ui()
	game_timer.start()

func _on_increase_button_pressed():
	if game_active:
		count += 1
		update_ui()

func _on_reset_button_pressed():
	prepare_new_round()

func _on_game_timer_timeout():
	if not game_active:
		return

	time_left -= 1
	update_ui()

	if time_left <= 0:
		finish_round()

func finish_round():
	game_active = false
	game_timer.stop()

	start_button.disabled = false
	increase_button.disabled = true

	var diff = count - target_score

	if diff >= 0:
		status_label.text = "Kazandın!"
		if diff == 0:
			result_label.text = "Tam isabet!"
		else:
			result_label.text = "%d farkla kazandın!" % diff
	else:
		status_label.text = "Kaybettin!"
		result_label.text = "%d eksik kaldın." % abs(diff)
