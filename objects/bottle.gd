class_name Bottle
extends Food

@export var max_fill: float = 330
@export var filled_mat: ShaderMaterial

func _ready() -> void:
	super._ready()
	total_fill = water + alkohol + sugar
	
	filled_mat.set_shader_parameter("value", total_fill / max_fill)

func fill(chuck: Chuck) -> Chuck:
	var total_chuck: float = chuck.water + chuck.alkohol + chuck.sugar
	var to_be_filled: float = max_fill - total_fill
	var wanted_value: float = clampf(to_be_filled / total_chuck, 0, 1)
	
	water += chuck.water * wanted_value
	alkohol += chuck.alkohol * wanted_value
	sugar += chuck.sugar * wanted_value
	
	chuck.water *= 1 - wanted_value
	chuck.alkohol *= 1 - wanted_value
	chuck.sugar *= 1 - wanted_value
	
	total_fill = water + alkohol + sugar
	
	filled_mat.set_shader_parameter("value", total_fill / max_fill)
	
	return chuck

func empty(speed: float, delta: float) -> Chuck:
	var chuck = super.empty(speed, delta)
	total_fill = water + alkohol + sugar
	
	filled_mat.set_shader_parameter("value", total_fill / max_fill)
	return chuck
