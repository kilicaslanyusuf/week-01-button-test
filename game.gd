extends Node2D

var score := 0
var rng := RandomNumberGenerator.new()

@onready var score_label = $CanvasLayer/ScoreLabel
@onready var player = $Player
@onready var collectible = $Collectible

func _ready():
	rng.randomize()
	update_ui()
	move_collectible()

func _physics_process(_delta):
	check_collect()

func update_ui():
	score_label.text = "Skor: %d" % score

func move_collectible():
	var size = get_viewport_rect().size
	collectible.global_position = Vector2(
		rng.randi_range(40, int(size.x) - 40),
		rng.randi_range(40, int(size.y) - 40)
	)

func check_collect():
	if player.global_position.distance_to(collectible.global_position) < 25:
		score += 1
		update_ui()
		move_collectible()
