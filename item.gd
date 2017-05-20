extends Node



func _ready():
	pass

func apply_effect(hp):
	hp["health_point"] += 200
	if hp["health_point"] > hp["max_hp"]:
		hp["health_point"] = hp["max_hp"]
#	queue_free() 