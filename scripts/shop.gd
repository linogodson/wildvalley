extends CanvasLayer

@onready var panel = $Panel
@onready var name_label = $Panel/Control/Name
@onready var des_label = $Panel/Control/Des
@onready var buy_button = $Panel/Control/Buy
@onready var icon = $Panel/Control/Icon   # TextureRect

var curr_item: int = 0

func _ready() -> void:
	panel.visible = false
	add_to_group("Shop")
	update_display()

func toggle() -> void:
	panel.visible = !panel.visible

func is_open() -> bool:
	return panel.visible

func _on_close_pressed() -> void:
	panel.visible = false

func update_display() -> void:
	if curr_item in Global.items:
		var item = Global.items[curr_item]
		
		name_label.text = item["Name"]
		des_label.text = "%s\n(Cost: %d)" % [item["Des"], item["Cost"]]
		buy_button.text = "Purchase (%d coins)" % item["Cost"]

		# Set fruit picture
		if item.has("Icon"):
			icon.texture = item["Icon"]
		else:
			icon.texture = null

func _on_next_pressed() -> void:
	curr_item = (curr_item + 1) % Global.items.size()
	update_display()

func _on_prev_pressed() -> void:
	curr_item = (curr_item - 1 + Global.items.size()) % Global.items.size()
	update_display()

func _on_buy_pressed() -> void:
	if curr_item in Global.items:
		var item = Global.items[curr_item]

		if Global.gold >= item["Cost"]:
			Global.gold -= item["Cost"]
			print("Bought %s, gold left: %d" % [item["Name"], Global.gold])

			var found = false
			for key in Global.inventory.keys():
				if Global.inventory[key]["Name"] == item["Name"]:
					Global.inventory[key]["Count"] += 1
					found = true
					break
			if not found:
				var new_id = Global.inventory.size()
				Global.inventory[new_id] = {
					"Name": item["Name"],
					"Des": item["Des"],
					"Cost": item["Cost"],
					"Count": 1
				}
		else:
			print("Not enough coins to buy %s!" % item["Name"])
