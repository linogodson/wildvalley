extends Area2D

@onready var timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	print("You Died!")
	timer.start()
	if body.has_method("add_coin"):
		queue_free()
func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
