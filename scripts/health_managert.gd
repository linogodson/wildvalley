extends Node

@export var max_health: int = 3
var current_health: int

signal on_health_changed(current_health: int)

func _ready() -> void:
	add_to_group("HealthManager")
	current_health = max_health
	on_health_changed.emit(current_health)
	print("HealthManager initialized = max health:", max_health)

func decrease_health(amount: int) -> void:
	if amount <= 0:
		return
	current_health = clamp(current_health - amount, 0, max_health)
	print("Health decreased to:", current_health)
	on_health_changed.emit(current_health)

func increase_health(amount: int) -> void:
	if amount <= 0:
		return
	current_health = clamp(current_health + amount, 0, max_health)
	print("Health increased to:", current_health)
	on_health_changed.emit(current_health)

func reset_health() -> void:
	current_health = max_health
	on_health_changed.emit(current_health)
