extends CharacterBody2D

@export var speed: float = 150
@export var jump_force: float = 350
@export var gravity: float = 900
@export var max_hearts: int = 10
@export var respawn_time: float = 2.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var heart_ui = get_tree().get_first_node_in_group("HeartsUI")

var shop
var hearts: int = 3
var is_dead: bool = false
var can_move: bool = true
var invincible: bool = false

func _ready() -> void:
	add_to_group("Player")
	shop = get_tree().get_first_node_in_group("Shop")
	update_heart_ui()

func _physics_process(delta: float) -> void:
	if is_dead or not can_move:
		return
	
	if shop and shop.is_open():
		velocity.x = 0
		anim.play("idle")
		return
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	velocity.x = 0
	if Input.is_action_pressed("move_left"):
		velocity.x = -speed
	elif Input.is_action_pressed("move_right"):
		velocity.x = speed
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force
	
	move_and_slide()
	update_animation()
	
	if Input.is_action_just_pressed("interact") and shop:
		shop.toggle()

func update_animation() -> void:
	if not is_on_floor():
		anim.play("jump")
		anim.flip_h = velocity.x < 0
	elif abs(velocity.x) > 0:
		anim.play("run")
		anim.flip_h = velocity.x < 0
	else:
		anim.play("idle")

func add_coin() -> void:
	Global.gold += 1

func spend_coins(amount: int) -> bool:
	if Global.gold >= amount:
		Global.gold -= amount
		return true
	return false

func add_heart() -> void:
	if hearts < max_hearts:
		hearts += 1
		update_heart_ui(true)

func heal(amount: int = 1) -> void:
	if is_dead:
		return
	hearts = clamp(hearts + amount, 0, max_hearts)
	update_heart_ui(true)

func take_damage() -> void:
	if is_dead or invincible:
		return
	
	if hearts > 0:
		hearts -= 1
		update_heart_ui()
		flash_red()
		start_invincibility(1.0)
	
	if hearts <= 0:
		die()

func start_invincibility(duration: float) -> void:
	invincible = true
	var blink_timer = get_tree().create_timer(duration)
	var blink_tween = get_tree().create_tween().set_loops(6)
	blink_tween.tween_property(anim, "modulate", Color(1, 1, 1, 0.4), 0.1)
	blink_tween.tween_property(anim, "modulate", Color(1, 1, 1, 1.0), 0.1)
	await blink_timer.timeout
	invincible = false
	anim.modulate = Color(1, 1, 1, 1)

func flash_red():
	var tween = get_tree().create_tween()
	anim.modulate = Color(1, 0.3, 0.3)
	tween.tween_property(anim, "modulate", Color(1, 1, 1), 0.3)

func die() -> void:
	if is_dead:
		return
	is_dead = true
	can_move = false
	velocity = Vector2.ZERO
	if "dead" in anim.sprite_frames.get_animation_names():

		anim.play("death")
		await anim.animation_finished
	else:
		await get_tree().create_timer(1.0).timeout
	
	await get_tree().create_timer(respawn_time).timeout
	respawn()

func respawn():
	var current_scene = get_tree().current_scene
	var new_scene = load(current_scene.scene_file_path).instantiate()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene.queue_free()

func update_heart_ui(pop_new := false) -> void:
	if heart_ui:
		for i in range(heart_ui.get_child_count()):
			var heart = heart_ui.get_child(i)
			heart.visible = i < hearts
			if pop_new and i == hearts - 1:
				heart.scale = Vector2(0.2, 0.2)
				var tween = get_tree().create_tween()
				tween.tween_property(heart, "scale", Vector2(1, 1), 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		print("Enemy entered ", body.damage_amount)
		HealthManagert.decrease_health(1)
