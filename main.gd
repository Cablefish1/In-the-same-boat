extends Control

var message_window : PackedScene = load("res://event scenes/intro_message.tscn")


#UI Elements
@onready var money_bar: ProgressBar = $"AssetPanel/Assets container/MoneyContainer/MoneyBar"
@onready var army_bar: ProgressBar = $"AssetPanel/Assets container/Army/ArmyBar"
@onready var pr_bar: ProgressBar = $"AssetPanel/Assets container/PR/PRBar"
@onready var money_amount_label: Label = $"AssetPanel/Assets container/MoneyContainer/MoneyBar/MoneyAmount"
@onready var army_amount_label: Label = $"AssetPanel/Assets container/Army/ArmyBar/ArmyAmount"
@onready var pr_amount_label: Label = $"AssetPanel/Assets container/PR/PRBar/PRAmount"

@onready var timekeeper: Label = $Timekeeper/Label


#Dicebag
@onready var dicebag = Dicebag.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Call the intro-text into existance
	spawn_message("res://event scenes/intro_message.tscn")
	rename_files_for_web()
	populate_random_event_table()
	update_ui()

func rename_files_for_web():
	var dir = DirAccess.open("res://event scenes/")
	if dir:
		dir.list_dir_begin()
		var dir_entry_name = dir.get_next()
		while dir_entry_name != "":
			print(dir_entry_name)
			dir_entry_name = dir.get_next()
		

func populate_random_event_table():
	var dir = DirAccess.open("res://event scenes/random events/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			Globals.random_event_scenes.append("res://event scenes/random events/" + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.") #debug
	


	
func spawn_message(message_scene: String):
	disable_all_buttons()
	message_window = load(message_scene)
	var current_message_window = message_window.instantiate()
	add_child(current_message_window)
	current_message_window.enable_buttons.connect(enable_all_buttons)


func advance_time():
	timekeeper.update_time()
	update_ui()
	
	
	


func update_ui():
	#update player assets
	money_bar.value = Globals.money
	money_amount_label.set_text(str(Globals.money))
	army_bar.value = Globals.army
	army_amount_label.set_text(str(Globals.army))
	pr_bar.value = Globals.pr_ppl
	pr_amount_label.set_text(str(Globals.pr_ppl))
	
	#Update action panel
	$StandardActionsPanel/VBoxContainer/BuyGoldButton.set_text("Buy gold bar\n"+str(Globals.gold_price)+" (C)")
	$StandardActionsPanel/VBoxContainer/BuyArmyButton.set_text("Buy private security\n"+str(Globals.army_price)+" (C)")
	$StandardActionsPanel/VBoxContainer/BuyPRppl.set_text("Buy PR people\n"+str(Globals.prppl_price)+" (C)")
	$StandardActionsPanel/VBoxContainer/BuySuppliesButton.set_text("Buy supplies\n"+str(Globals.supplies_price)+" (C)")
	
	#update victory progress
	$WinConditionPanel/VBoxContainer/HBoxContainer/GoldProgressCotainer/GoldProgress.value = Globals.gold_stockpile
	$WinConditionPanel/VBoxContainer/HBoxContainer/GoldProgressCotainer/GoldProgress.max_value = Globals.gold_to_win
	$WinConditionPanel/VBoxContainer/HBoxContainer/GoldProgressCotainer/GoldProgress/GoldProgressLabel.set_text(str(Globals.gold_stockpile)+"/"+str(Globals.gold_to_win))
	$WinConditionPanel/VBoxContainer/HBoxContainer/SupplyProgressContainer/SupplyProgress.value = Globals.supply_stockpile
	$WinConditionPanel/VBoxContainer/HBoxContainer/SupplyProgressContainer/SupplyProgress.max_value = Globals.supply_to_win
	$WinConditionPanel/VBoxContainer/HBoxContainer/SupplyProgressContainer/SupplyProgress/SupplyProgressLabel.set_text(str(Globals.supply_stockpile)+"/"+str(Globals.supply_to_win))
	$WinConditionPanel/VBoxContainer/HBoxContainer/ShelterConstruction/ShelterProgress.value = Globals.hideout_progress
	$WinConditionPanel/VBoxContainer/HBoxContainer/ShelterConstruction/ShelterProgress.max_value = Globals.hideout_complete_number
	$WinConditionPanel/VBoxContainer/HBoxContainer/ShelterConstruction/ShelterProgress/ShelterProgressLabel.set_text(str(Globals.hideout_progress)+"/"+str(Globals.hideout_complete_number))
	# Update Panic Panel
	$PanicPanel/VBoxContainer/PanicProgress.value = Globals.panic_level
	#update protest camp size
	$ProtestPanel/VBoxContainer/ProtestProgress.value = Globals.protest_camp_size
	$ProtestPanel/VBoxContainer/ProtestProgress/Label.set_text(str(Globals.protest_camp_size)+"/10000")

func disable_all_buttons():
	var all_buttons : Array = find_children("*","Button")
	for i in all_buttons:
		i.disabled = true


func enable_all_buttons():
	var all_buttons : Array = find_children("*","Button")
	for i in all_buttons:
		i.disabled = false
	update_ui()

#Buy stuff buttons

func _on_buy_gold_button_pressed() -> void:
	if Globals.gold_price > Globals.money:
		spawn_message("res://event scenes/not_enough_cash.tscn")
		return
	if Globals.gold_stockpile == Globals.gold_to_win:
		spawn_message("res://event scenes/already_at_max.tscn")
	Globals.money = Globals.money - Globals.gold_price
	Globals.gold_stockpile = Globals.gold_stockpile + 1
	check_if_won()
	update_ui()
	
	

func _on_buy_army_button_pressed() -> void:
	if Globals.army_price > Globals.money:
		spawn_message("res://event scenes/not_enough_cash.tscn")
		return
	Globals.money = Globals.money - Globals.army_price
	Globals.army = Globals.army + 10
	update_ui()
	


func _on_buy_p_rppl_pressed() -> void:
	if Globals.prppl_price > Globals.money:
		spawn_message("res://event scenes/not_enough_cash.tscn")
		return
	Globals.money = Globals.money - Globals.prppl_price
	Globals.pr_ppl = Globals.pr_ppl + 1
	update_ui()

# Buy Victory Stuff buttons
func _on_buy_supplies_button_pressed() -> void:
	if Globals.supplies_price > Globals.money:
		spawn_message("res://event scenes/not_enough_cash.tscn")
		return
	if Globals.supply_stockpile == Globals.supply_to_win:
		spawn_message("res://event scenes/already_at_max.tscn")
	Globals.money = Globals.money - Globals.supplies_price
	Globals.supply_stockpile += 1
	check_if_won()
	update_ui()
	

# Turn ending action buttons


func _on_get_money_button_pressed() -> void:
	Globals.money = Globals.money + dicebag.roll_dice(1,50, Globals.liquidate_money_modifier)
	advance_time()

func _on_build_shelter_button_pressed() -> void:
	Globals.hideout_progress += 1
	if check_if_won() == false:
			advance_time()



func _on_go_golfing_button_pressed() -> void:
	if Globals.tut_has_golfed_1st_time  == false:
		spawn_message("res://event scenes/timed events/golfing_1st_time.tscn")
		Globals.tut_has_golfed_1st_time = true
		$TurnEndingActions/VBoxContainer/GetMoneyButton.show()
	else:
		spawn_message("res://event scenes/golfing.tscn")

	advance_time()
	
func check_if_won():
	if(Globals.gold_stockpile >= Globals.gold_to_win && Globals.supply_stockpile >= Globals.supply_to_win && Globals.hideout_progress >= Globals.hideout_complete_number):
		spawn_message("res://event scenes/game_won.tscn")
		return true
	return false

# Avoid loss condition buttons

func _on_lobby_button_pressed() -> void:
	if Globals.pr_ppl < 1:
		spawn_message("res://event scenes/no_prppl.tscn")
		return
	if Globals.panic_level < 1:
		spawn_message("res://event scenes/panic_at_zero.tscn")
		return
	Globals.panic_level -= 10
	Globals.pr_ppl -= 1
	update_ui()

func _on_motivate_button_pressed() -> void:
	if Globals.army < 10:
		spawn_message("res://event scenes/no_prppl.tscn") #Replace with not enough security msg
		return
	if Globals.protest_camp_size < 1:
		spawn_message("res://event scenes/panic_at_zero.tscn") #Replace with no encampment button
		return
	Globals.protest_camp_size -= 100
	Globals.army -= 10
	update_ui()
