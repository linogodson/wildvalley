extends CharacterBody2D

@export var speed: float = 150.0
@export var jump_force: float = 350.0
@export var gravity: float = 900.0
@export var respawn_time: float = 1.0
var is_dead: bool = false
var can_move: bool = true
var invincible: bool = false

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_manager = get_tree().get_first_node_in_group("HealthManager")
@onready var stx_jump = $stx_jump

func _ready():
	add_to_group("Player")

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	if not is_on_floor():
		velocity.y += gravity * delta

	var direction := Input.get_axis("ui_left", "ui_right")
	if can_move:
		velocity.x = direction * speed
	else:
		velocity.x = 0

	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and can_move:
		velocity.y = -jump_force

	move_and_slide()

	if direction != 0:
		anim.flip_h = direction < 0

	if not is_on_floor():
		anim.play("jump")
	elif direction != 0:
		anim.play("run")
		stx_jump.play()
	else:
		anim.play("idle")


func add_coin() -> void:
	var global = get_node_or_null("/root/Global")
	if global:
		global.gold += 1
		%coin_hehe.play()
func add_heart() -> void:
	if health_manager:
		health_manager.increase_health(1)

func take_damage(source: Node2D = null) -> void:
	if is_dead or invincible:
		return

	if health_manager:
		health_manager.decrease_health(1)
		flash_red()
		start_invincibility(1.0)

		if source:
			var knock_dir = (global_position - source.global_position).normalized()
			velocity = knock_dir * 220 + Vector2(0, -140)

		if health_manager.current_health <= 0:
			die()

func start_invincibility(duration: float) -> void:
	invincible = true
	var blink_timer = get_tree().create_timer(duration)
	var blink_tween = get_tree().create_tween().set_loops(6)
	blink_tween.tween_property(anim, "modulate", Color(1, 1, 1, 0.35), 0.1)
	blink_tween.tween_property(anim, "modulate", Color(1, 1, 1, 1.0), 0.1)
	await blink_timer.timeout
	invincible = false
	anim.modulate = Color(1, 1, 1, 1)

func flash_red() -> void:
	var tween = get_tree().create_tween()
	anim.modulate = Color(1, 0.3, 0.3)
	tween.tween_property(anim, "modulate", Color(1, 1, 1), 0.3)

func die() -> void:
	if is_dead:
		return
	is_dead = true
	can_move = false
	velocity = Vector2.ZERO

	if anim.sprite_frames and anim.sprite_frames.has_animation("death"):
		anim.play("death")
		await anim.animation_finished
	else:
		await get_tree().create_timer(1.0).timeout

	await get_tree().create_timer(respawn_time).timeout
	respawn()

func respawn() -> void:
	var current_scene = get_tree().current_scene
	if current_scene == null:
		if get_tree().root.get_child_count() > 0:
			current_scene = get_tree().root.get_child(0)
		else:
			push_error("Respawn failed: no current scene or root child found.")
			return

	var path = current_scene.scene_file_path
	if path == "":
		push_error("Respawn failed: current scene has no file path.")
		return

	var new_scene = load(path).instantiate()
	get_tree().root.add_child(new_scene)
	current_scene.queue_free()
