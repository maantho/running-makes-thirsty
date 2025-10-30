class_name Food
extends Entity

@export var water: float
@export var alkohol: float
@export var sugar: float

var total_fill: float

func _ready() -> void:
	total_fill = water + alkohol + sugar
	print(total_fill)

func return_chuck(chuck: Chuck) -> void:
	water += chuck.water
	alkohol += chuck.alkohol
	sugar += chuck.sugar
	
	total_fill = water + alkohol + sugar


func empty(speed: float, delta: float) -> Chuck:
	var requestet_fill: float = speed * delta
	var empty_value := clampf(requestet_fill / total_fill, 0, 1) 
	
	var chuck := Chuck.new(water * empty_value, alkohol * empty_value, sugar * empty_value)
	
	water -= chuck.water
	alkohol -= chuck.alkohol
	sugar -= chuck.sugar
	
	total_fill = water + alkohol + sugar
	return chuck

func get_weight() -> float:
	return super.get_weight() + total_fill
