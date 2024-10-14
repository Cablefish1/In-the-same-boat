extends Button


@export var global_var_name : String = ""
@export var amount_to_change : int = 0

@export var global_var_name2 : String = ""
@export var amount_to_change2 : int = 0

@export var global_var_name3 : String = ""
@export var amount_to_change3 : int = 0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	change_global_vars()
	



func change_global_vars():
	match global_var_name:
		
		"money":
			Globals.money = Globals.money + amount_to_change
			check_for_more_changes()
		
		"panic_level":
			Globals.panic_level = Globals.panic_level + amount_to_change
			check_for_more_changes()
		
		"protest_camp_size":
			Globals.protest_camp_size = Globals.protest_camp_size + amount_to_change
		
		"liquidate_money_modifier":
			Globals.liquidate_money_modifier = Globals.liquidate_money_modifier + amount_to_change
			print(Globals.liquidate_money_modifier)
			check_for_more_changes()
		
		"hideout_progress":
			Globals.hideout_progress = Globals.hideout_progress + amount_to_change
			if Globals.hideout_progress < 0:
				Globals.hideout_progress = 0 # prevent hideout progress being less than 0
			
		"supply_stockpile":
			print("Supply stockpile should be going down")
			Globals.supply_stockpile = Globals.supply_stockpile + amount_to_change
			if Globals.supply_stockpile < 0:
				Globals.supply_stockpile = 0 # Prevent supply stockpile going below 0
	
		_:
			print("ERROR: Bad global var name")
			check_for_more_changes()
			
	$"../..".close_window()

func check_for_more_changes():
	if global_var_name2 != "":
		global_var_name = global_var_name2
		amount_to_change = amount_to_change2
		global_var_name2 = ""
		change_global_vars()
	if global_var_name3 != "":
		global_var_name = global_var_name3
		amount_to_change = amount_to_change3
		global_var_name2 = ""
		change_global_vars()
	
