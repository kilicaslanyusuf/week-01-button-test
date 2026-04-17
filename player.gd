extends CharacterBody2D

@export var speed := 300.0

var screen_size: Vector2
var clamp_margin_x := 20.0
var clamp_margin_y := 20.0

@onready var collision_shape = $CollisionShape2D

func _ready():
	screen_size = get_viewport_rect().size
	setup_clamp_margins()

func setup_clamp_margins():
	var shape = collision_shape.shape

	if shape is CircleShape2D:
		clamp_margin_x = shape.radius
		clamp_margin_y = shape.radius
	elif shape is RectangleShape2D:
		clamp_margin_x = shape.size.x / 2.0
		clamp_margin_y = shape.size.y / 2.0

func _physics_process(_delta):
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed
	move_and_slide()

	global_position.x = clamp(global_position.x, clamp_margin_x, screen_size.x - clamp_margin_x)
	global_position.y = clamp(global_position.y, clamp_margin_y, screen_size.y - clamp_margin_y)
