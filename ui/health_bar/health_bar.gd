extends Node2D

@export var heart1: Texture2D
@export var heart0: Texture2D

@onready var heart_1: Sprite2D = $Heart1
@onready var heart_2: Sprite2D = $Heart2
@onready var heart_3: Sprite2D = $Heart3

func _ready():
	await get_tree().process_frame
	var health_manager = get_tree().get_first_node_in_group("HealthManager")
	if health_manager:
		if health_manager.has_signal("on_health_changed"):
			health_manager.on_health_changed.connect(_on_player_health_changed)
			_on_player_health_changed(health_manager.current_health)
			print("Connected to HealthManager signal successfully!")
		else:
			print("HealthManager found but missing signal 'on_health_changed'")
	else:
		print("HealthManager node not found in group!")

func _on_player_health_changed(player_current_health: int):
	print("Health changed:", player_current_health)
	heart_1.texture = heart1 if player_current_health >= 1 else heart0
	heart_2.texture = heart1 if player_current_health >= 2 else heart0
	heart_3.texture = heart1 if player_current_health >= 3 else heart0
