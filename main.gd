extends Control

var count := 0
var time_left := 10
var game_active := false
var target_score := 15

@onready var status_label = $CenterContainer/VBoxContainer/StatusLabel
@onready var target_label = $CenterContainer/VBoxContainer/TargetLabel
@onready var counter_label = $CenterContainer/VBoxContainer/CounterLabel
@onready var time_label = $CenterContainer/VBoxContainer/TimeLabel
@onready var game_timer = $CenterContainer/VBoxContainer/GameTimer

func _ready():
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
	update_ui()
	game_timer.start()

func _on_increase_button_pressed():
	if game_active:
		count += 1
		update_ui()

func _on_reset_button_pressed():
	count = 0
	time_left = 10
	game_active = false
	status_label.text = "Hazır"
	update_ui()
	game_timer.stop()

func _on_game_timer_timeout():
	if game_active:
		time_left -= 1
		update_ui()

		if time_left <= 0:
			game_active = false
			game_timer.stop()

			if count >= target_score:
				status_label.text = "Kazandın!"
			else:
				status_label.text = "Kaybettin!"
