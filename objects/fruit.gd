class_name Fruit
extends Food

enum TypeEnum {CITRUS, JUICY}

@export var type: TypeEnum

var start_total_fill: float

func _ready() -> void:
	super._ready()
	start_total_fill = total_fill


func _process(delta: float) -> void:
	super._process(delta)
	var value: float = total_fill / start_total_fill
	scale = Vector2(value, value)
	
	if value <= 0:
		grabbed.emit(self)
		queue_free()
