extends Button

@export var money_cost : int = 50


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Check if any options are to be disabled
	if (Globals.money < money_cost): 
		$".".disabled = true



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	Globals.money = Globals.money - money_cost
	$"../..".close_window()
	
