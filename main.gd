extends Control

var count := 0

@onready var counter_label = $CenterContainer/VBoxContainer/CounterLabel

func _ready():
	update_label()

func update_label():
	counter_label.text = "Tıklama sayısı: %d" % count

func _on_increase_button_pressed():
	count += 1
	update_label()

func _on_reset_button_pressed():
	count = 0
	update_label()
