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
@onready var hazard = $Hazard
@onready var bonus = $Bonus
@onready var game_timer = $GameTimer

func _ready():
	rng.randomize()
	start_new_game()

func start_new_game():
	score = 0
	time_left = 20
	game_active = true
	status_label.text = "Topla, kaçın, bonusu kap!"

	move_collectible([])
	move_hazard([collectible.global_position])
	move_bonus([collectible.global_position, hazard.global_position])

	update_ui()
	game_timer.start()

func _physics_process(_delta):
	if game_active:
		check_collect()
		check_hazard()
		check_bonus()

	if Input.is_action_just_pressed("ui_accept") and not game_active:
		start_new_game()

func update_ui():
	score_label.text = "Skor: %d" % score
	best_score_label.text = "En iyi skor: %d" % best_score
	time_label.text = "Süre: %d" % time_left

func get_safe_random_position(excluded_positions: Array, min_distance: float) -> Vector2:
	var size = get_viewport_rect().size

	for i in range(200):
		var candidate = Vector2(
			rng.randi_range(80, int(size.x) - 80),
			rng.randi_range(80, int(size.y) - 80)
		)

		var valid = true

		for pos in excluded_positions:
			if candidate.distance_to(pos) < min_distance:
				valid = false
				break

		if valid:
			return candidate

	return Vector2(200, 200)	

func move_collectible(excluded_positions: Array = []):
	collectible.global_position = get_safe_random_position(excluded_positions, 140.0)

func move_hazard(excluded_positions: Array = []):
	hazard.global_position = get_safe_random_position(excluded_positions, 140.0)

func move_bonus(excluded_positions: Array = []):
	bonus.global_position = get_safe_random_position(excluded_positions, 140.0)

func check_collect():
	if player.global_position.distance_to(collectible.global_position) < 25:
		score += 1

		if score > best_score:
			best_score = score

		status_label.text = "Topladın!"
		update_ui()
		move_collectible([hazard.global_position, bonus.global_position])

func check_hazard():
	if player.global_position.distance_to(hazard.global_position) < 28:
		time_left -= 3

		if time_left < 0:
			time_left = 0

		status_label.text = "Çarptın! -3 saniye"
		update_ui()
		move_hazard([collectible.global_position, bonus.global_position])

		if time_left <= 0:
			finish_game()

func check_bonus():
	if player.global_position.distance_to(bonus.global_position) < 25:
		time_left+=2
		status_label.text="Bonus! +2 saniye"
		update_ui()
		move_bonus([collectible.global_position, hazard.global_position])

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
