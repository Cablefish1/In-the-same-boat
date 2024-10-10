extends Panel

@onready var text: RichTextLabel = $VBoxContainer/Text
signal enable_buttons


#close window
func _on_center_pressed() -> void:
	enable_buttons.emit()
	queue_free()

func close_window():
	enable_buttons.emit()
	queue_free()

# Probably unused script
func _on_restart_game_pressed() -> void:
	get_tree().quit()

# EVENT SPECIFIC BUTTON FUNCTIONS:
func _on_use_army_button_pressed() -> void:
	Globals.army -= 2
	close_window()

# Shelter construction event
func _on_moutains_pressed() -> void:
	Globals.hideout_complete_number = 20
	Globals.shelter_type = "mountains"
	close_window()

func _on_pacific_pressed() -> void:
	Globals.hideout_complete_number = 30
	Globals.shelter_type = "pacific"
	close_window()

func _on_mars_pressed() -> void:
	Globals.hideout_complete_number = 50
	Globals.shelter_type = "mars"
	Globals.gold_price += 5
	Globals.gold_price_minimum += 5
	Globals.supplies_price += 5
	Globals.supplies_price_minimum += 5
	close_window()
