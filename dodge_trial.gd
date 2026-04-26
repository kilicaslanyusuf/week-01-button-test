extends Node2D

var enemy_speed := 180.0
var time_left := 15
var game_active := false

@onready var time_label = $CanvasLayer/UIBox/TimeLabel
@onready var status_label = $CanvasLayer/UIBox/StatusLabel
@onready var player = $Player
@onready var enemy = $Enemy
@onready var game_timer = $GameTimer

func _ready():
	show_start_screen()

func show_start_screen():
	time_left = 15
	game_active = false
	game_timer.stop()
	player.visible = false
	enemy.visible = false
	update_ui()
	status_label.text = "Başlamak için Enter"

func start_game():
	time_left = 15
	game_active = true
	player.visible = true
	enemy.visible = true
	player.global_position = Vector2(200, 200)
	enemy.global_position = Vector2(900, 500)
	update_ui()
	status_label.text = "Kaç!"
	game_timer.start()

func update_ui():
	time_label.text = "Süre: %d" % time_left

func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_accept") and not game_active:
		start_game()

	if game_active:
		move_enemy(_delta)
		check_enemy_collision()

func move_enemy(delta):
	var direction = (player.global_position - enemy.global_position).normalized()
	enemy.global_position += direction * enemy_speed * delta

func check_enemy_collision():
	if player.global_position.distance_to(enemy.global_position) < 30:
		finish_game(false)

func _on_game_timer_timeout():
	if not game_active:
		return

	time_left -= 1
	update_ui()

	if time_left <= 0:
		finish_game(true)

func finish_game(won: bool):
	game_active = false
	game_timer.stop()
	player.visible = true
	enemy.visible = true

	if won:
		status_label.text = "Kazandın! Enter ile tekrar başla"
	else:
		status_label.text = "Yakalandın! Enter ile tekrar başla"
