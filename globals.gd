extends Node

@onready var dicebag = Dicebag.new()

@export var shelter_type : String = ""

@export_category("Player Assets")
@export var money : int = 100
@export var pr_ppl : int = 10
@export var army : int = 10


@export_category("Global Vars")
@export var panic_level : int = 0
@export var protest_camp_size : int = 0

@export var gold_price : int = 15
@export var gold_price_minimum : int = 10
@export var army_price : int = 15
@export var prppl_price : int = 30
@export var supplies_price : int = 10
@export var supplies_price_minimum : int = 10

@export_category("Victory Conditions")
@export var gold_stockpile : int = 0
@export var gold_to_win : int = 20
@export var hideout_progress : int = 0
@export var hideout_complete_number : int = 20
@export var supply_stockpile : int = 0
@export var supply_to_win : int = 20

# Random event table:
@export var random_event_scenes : Array = []


# Mechanics variables
var gold_rise : int = 3
var liquidate_money_modifier : int = 40
var max_monthly_panic_gain : int = 4
var protest_increase_modifier : int = 10

# UI Variables


# Tutorial vars
var tut_has_golfed_1st_time : bool = false



func update_gold_price(): #should probably be moved to the timekeeper
	randomize()
	gold_price = gold_price + gold_rise
	gold_price = gold_price - dicebag.roll_dice(1,6)
	if(gold_price <= gold_price_minimum):
		gold_price = gold_price_minimum
		
