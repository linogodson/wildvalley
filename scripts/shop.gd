extends CanvasLayer

@onready var item_container = $ItemContainer
@onready var gold_label = $GoldLabel

func _ready() -> void:
	update_gold_display()
	populate_shop()

func update_gold_display() -> void:
	gold_label.text = "Gold: " + str(Global.gold)

func populate_shop() -> void:
	item_container.clear()
	for i in Global.items.keys():
		var item_data = Global.items[i]
		var button = Button.new()
		button.text = "%s - %dG" % [item_data["Name"], item_data["Cost"]]
		button.connect("pressed", Callable(self, "_on_item_pressed").bind(i))
		item_container.add_child(button)

func _on_item_pressed(item_id: int) -> void:
	var item_data = Global.items[item_id]
	if Global.gold >= item_data["Cost"]:
		Global.gold -= item_data["Cost"]
		update_gold_display()

		if Global.inventory.has(item_id):
			Global.inventory[item_id] += 1
		else:
			Global.inventory[item_id] = 1

		print("Bought", item_data["Name"], "- You now have", Global.inventory[item_id])
	else:
		print("Not enough gold for", item_data["Name"])
