extends Node2D

@export var max_hearts: int = 10
@onready var heart_container = $HBoxContainer
@onready var player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	position = Vector2(0, -40)

	var health_manager = get_tree().get_first_node_in_group("HealthManager")
	if health_manager and health_manager.has_signal("on_health_changed"):
		health_manager.on_health_changed.connect(update_hearts)
		update_hearts(health_manager.current_health)
	else:
		push_warning("⚠️ HealthManager not found or missing signal!")

func _process(delta: float) -> void:
	if player:
		global_position = player.global_position + Vector2(0, -40)

func update_hearts(current: int) -> void:
	for i in range(max_hearts):
		heart_container.get_child(i).visible = i < current
