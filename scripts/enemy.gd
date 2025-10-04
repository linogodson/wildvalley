extends CharacterBody2D

@export var speed: float = 50
@export var damage_cooldown: float = 1.0
@export var damage_amount : int = 1

var player: Node = null
var can_damage: bool = true

func _ready() -> void:
	add_to_group("Enemy")
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:
	if not player:
		return

	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

	$AnimatedSprite2D.flip_h = velocity.x < 0

func _on_area_2d_body_entered(body: Node) -> void:
	if not can_damage:
		return

	if body.is_in_group("Player"):
		can_damage = false
		body.take_damage()
		await get_tree().create_timer(damage_cooldown).timeout
		can_damage = true
		
		
