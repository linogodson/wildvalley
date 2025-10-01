extends Node2D


var required_coins = 5
@onready var sprite = $Sprite2D
@onready var area = $Area2D

func _ready():
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player") and body.coins >= required_coins:
		open_door()

func open_door():
	sprite.modulate = Color(0.5, 1, 0.5)
	print("Door opened! Level complete.")
