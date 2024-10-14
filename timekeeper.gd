extends Label

#Nodes/tools reference
@onready var dicebag = Dicebag.new()
@onready var main: Control = $"../.."



# vars
@export var month : int = 1
@export var year : int = 2030

# Random event chance in percent
@export var random_event_chance : int = 30

var month_str

func update_time():
	month += 1
	# Raise global panic level
	Globals.panic_level = Globals.panic_level + dicebag.roll_dice(1, Globals.max_monthly_panic_gain, -1)
	if Globals.panic_level >= 100:
		main.spawn_message("res://event scenes/game_over_panic.tscn")
	
	# Increase protest camp size
	Globals.protest_camp_size = Globals.protest_camp_size + (dicebag.roll_dice(1, 10) * Globals.protest_increase_modifier)
	
	# Check for lost conditions
	if Globals.panic_level >= 100:
		main.spawn_message("res://event scenes/game_over_panic.tscn")
	if Globals.protest_camp_size >= 10000:
		main.spawn_message("res://event scenes/game_over_protest.tscn")
	
	if(month == 13):
		year += 1
		month = 1
		# Price of gold rise faster every year
		Globals.gold_rise = Globals.gold_rise + 1
		# You gain less and less money when you liquidate
		Globals.liquidate_money_modifier = Globals.liquidate_money_modifier - 10
		if Globals.liquidate_money_modifier <= 0: #can't have negative income
			Globals.liquidate_money_modifier = 0
		# Panic has a potential to rise more every year
		Globals.max_monthly_panic_gain += 2
		# More protesters flock to your mansion
		Globals.protest_increase_modifier += 10
		# Food prices go up by a fixed amount
		Globals.supplies_price += 10
		# events that have conditions have the potential to be added to the pool every year
		do_specific_year_stuff()
	month_to_str(month)
	set_text(month_str+"\n"+str(year))
	
	Globals.update_gold_price()
	do_timed_events()


	
		
	
	
func month_to_str(month_int):
	match month_int:
		1:
			month_str = "January"
		2:
			month_str = "February"
		3:
			month_str = "March"
		4:
			month_str = "April"
		5:
			month_str = "may"
		6:
			month_str = "June"
		7:
			month_str = "July"
		8:
			month_str = "August"
		9:
			month_str = "September"
		10:
			month_str = "October"
		11:
			month_str = "November"
		12:
			month_str = "December"


func check_and_do_event():
	pass


func do_timed_events():
	match [year, month]:
		[2030, 2]:
			pass #This is to prevent collision with the random event system which activates every month nothing else happens.
		[2030, 3]:
			main.spawn_message("res://event scenes/timed events/march_gold.tscn")
			$"../../StandardActionsPanel".show()
			$"../../WinConditionPanel".show()
		[2030, 4]:
			Globals.panic_level += 1
			$"../../PanicPanel".show()
			$"../../StandardActionsPanel/VBoxContainer/BuyPRppl".show()
			$"../../PanicPanel/VBoxContainer/LobbyButton".show()
			main.spawn_message("res://event scenes/timed events/april_panic.tscn")
		[2030, 5]:
			main.spawn_message("res://event scenes/timed events/may_protesters.tscn")
			$"../../StandardActionsPanel/VBoxContainer/BuyArmyButton".show()
			$"../../ProtestPanel".show()
			main.update_ui()
		[2030, 6]:
			$"../../WinConditionPanel/VBoxContainer/HBoxContainer/SupplyProgressContainer".show()
			$"../../StandardActionsPanel/VBoxContainer/BuySuppliesButton".show()
			main.spawn_message("res://event scenes/timed events/june_food.tscn")
		[2030, 7]:
			main.spawn_message("res://event scenes/timed events/july_shelter_choice.tscn")
			$"../../WinConditionPanel/VBoxContainer/HBoxContainer/ShelterConstruction".show()
			$"../../TurnEndingActions/VBoxContainer/BuildShelterButton".show()
		[2030, 8]:
			pass #Should either be removed or replaced with a good luck message

		# If nothing matches draw random event
		_:
			roll_for_random_event()

func do_specific_year_stuff():
	match year:
		2031:
			main.spawn_message("res://event scenes/timed events/year_one.tscn")
			#Append pacific shelter events
			if Globals.shelter_type == "pacific" && Globals.hideout_progress >= 3 && Globals.random_event_scenes.has("res://event scenes/pacific shelter events/rotating_fireplace.tscn") == false: #Doesn't seem to trigger
				Globals.random_event_scenes.append("res://event scenes/pacific shelter events/rotating_fireplace.tscn")


func roll_for_random_event():
	var dice_roll = dicebag.roll_dice(1, 100)
	if dice_roll <= random_event_chance:
		pick_and_do_event()

func pick_and_do_event():
	var event = Globals.random_event_scenes.pick_random()
	main.spawn_message(event)
