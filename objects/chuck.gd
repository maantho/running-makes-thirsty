class_name Chuck

var water: float
var alkohol: float
var sugar: float

@warning_ignore("shadowed_variable")
func _init(water: float, alkohol: float, sugar: float) -> void:
	self.water = water
	self.alkohol = alkohol
	self.sugar = sugar
