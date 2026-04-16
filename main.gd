extends Control

const SAVE_PATH := "user://save.cfg"

var count := 0
var time_left := 10
var game_active := false
var target_score := 15
var high_score := 0

var rng := RandomNumberGenerator.new()

@onready var status_label = $CenterContainer/VBoxContainer/StatusLabel
@onready var result_label = $CenterContainer/VBoxContainer/ResultLabel
@onready var target_label = $CenterContainer/VBoxContainer/TargetLabel
@onready var counter_label = $CenterContainer/VBoxContainer/CounterLabel
@onready var high_score_label = $CenterContainer/VBoxContainer/HighScoreLabel
@onready var time_label = $CenterContainer/VBoxContainer/TimeLabel
@onready var start_button = $CenterContainer/VBoxContainer/StartButton
@onready var increase_button = $CenterContainer/VBoxContainer/IncreaseButton
@onready var reset_button = $CenterContainer/VBoxContainer/ResetButton
@onready var game_timer = $CenterContainer/VBoxContainer/GameTimer

func _ready():
	rng.randomize()
	load_high_score()
	prepare_new_round()

func load_high_score():
	var config = ConfigFile.new()
	var err = config.load(SAVE_PATH)

	if err == OK:
		high_score = int(config.get_value("scores", "high_score", 0))
	else:
		high_score = 0

func save_high_score():
	var config = ConfigFile.new()
	config.set_value("scores", "high_score", high_score)
	config.save(SAVE_PATH)

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
	high_score_label.text = "En iyi skor: %d" % high_score
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
	var new_record := false

	if count > high_score:
		high_score = count
		save_high_score()
		new_record = true

	if diff >= 0:
		status_label.text = "Kazandın!"
		if diff == 0:
			result_label.text = "Tam isabet!"
		else:
			result_label.text = "%d farkla kazandın!" % diff
	else:
		status_label.text = "Kaybettin!"
		result_label.text = "%d eksik kaldın." % abs(diff)

	if new_record:
		result_label.text += " Yeni rekor!"

	update_ui()
