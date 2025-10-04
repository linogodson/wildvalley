extends CharacterBody2D

@export var speed: float = 150
@export var jump_force: float = 350
@export var gravity: float = 900

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var shop

func _ready() -> void:
	shop = get_tree().get_first_node_in_group("Shop")

func _physics_process(delta: float) -> void:
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

	if Input.is_action_just_pressed("interact"):
		if shop:
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
	print("Coins:", Global.gold)

func spend_coins(amount: int) -> bool:
	if Global.gold >= amount:
		Global.gold -= amount
		print("Bought item, coins left:", Global.gold)
		return true
	print("Not enough coins!")
	return false
