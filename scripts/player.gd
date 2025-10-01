extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_force: float = 450.0
@export var gravity: float = 1100.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var dir := Input.get_axis("ui_left", "ui_right")



	velocity.x = dir * speed


	if not is_on_floor():
		velocity.y += gravity * delta



	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = -jump_force

	move_and_slide()



	if dir != 0:
		anim.flip_h = dir < 0





	if not is_on_floor():
		if velocity.y < 0:
			anim.play("jump")
		else:
			anim.play("fall")
	else:
		if dir == 0:
			anim.play("idle")
		else:
			anim.play("run")
