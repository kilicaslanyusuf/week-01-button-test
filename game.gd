extends Node2D

var score := 0
var best_score := 0
var time_left := 20
var game_active := false

var rng := RandomNumberGenerator.new()

@onready var score_label = $CanvasLayer/UIBox/ScoreLabel
@onready var best_score_label = $CanvasLayer/UIBox/BestScoreLabel
@onready var time_label = $CanvasLayer/UIBox/TimeLabel
@onready var status_label = $CanvasLayer/UIBox/StatusLabel
@onready var player = $Player
@onready var collectible = $Collectible
@onready var game_timer = $GameTimer

func _ready():
	rng.randomize()
	start_new_game()

func start_new_game():
	score = 0
	time_left = 20
	game_active = true
	status_label.text = "Topla!"
	move_collectible()
	update_ui()
	game_timer.start()

func _physics_process(_delta):
	if game_active:
		check_collect()

	if Input.is_action_just_pressed("ui_accept") and not game_active:
		start_new_game()

func update_ui():
	score_label.text = "Skor: %d" % score
	best_score_label.text = "En iyi skor: %d" % best_score
	time_label.text = "Süre: %d" % time_left
	

func move_collectible():
	var size = get_viewport_rect().size
	collectible.global_position = Vector2(
		rng.randi_range(40, int(size.x) - 40),
		rng.randi_range(40, int(size.y) - 40)
	)

func check_collect():
	if player.global_position.distance_to(collectible.global_position) < 25:
		score += 1

		if score > best_score:
			best_score = score

		update_ui()
		move_collectible()

func _on_game_timer_timeout():
	if not game_active:
		return

	time_left -= 1
	update_ui()

	if time_left <= 0:
		finish_game()

func finish_game():
	game_active = false
	game_timer.stop()

	if score <= 4:
		status_label.text = "Zayıf tur. Enter ile tekrar dene."
	elif score <= 9:
		status_label.text = "İdare eder. Enter ile tekrar dene."
	else:
		status_label.text = "Güzel tur! Enter ile tekrar dene."
