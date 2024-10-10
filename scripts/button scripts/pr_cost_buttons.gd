extends Button

@export var prppl_cost : int = 5



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Check if any options are to be disabled
	if (Globals.pr_ppl < prppl_cost): 
		$".".disabled = true



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	Globals.pr_ppl = Globals.pr_ppl - prppl_cost
	$"../..".close_window()
