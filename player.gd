extends CharacterBody2D

@export var speed := 300.0
var screen_size: Vector2

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed
	move_and_slide()

	global_position.x = clamp(global_position.x, 30, screen_size.x - 30)
	global_position.y = clamp(global_position.y, 30, screen_size.y - 30)
