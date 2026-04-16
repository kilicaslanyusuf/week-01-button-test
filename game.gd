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

func update_ui():
	score_label.text = "Skor: %d" % score

func move_collectible():
	var size = get_viewport_rect().size
	collectible.global_position = Vector2(
		rng.randi_range(40, int(size.x) - 40),
		rng.randi_range(40, int(size.y) - 40)
	)

func _on_collectible_body_entered(body):
	if body == player:
		score += 1
		update_ui()
		move_collectible()
