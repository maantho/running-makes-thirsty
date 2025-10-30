class_name Spawner
extends Marker2D

@export var first_pos: float = 0
@export var distance: float = 20

@export var scene: PackedScene

var current_distance: float = 0

func _process(delta: float) -> void:
	if current_distance + first_pos - global_position.x / Level.PIXEL_PER_METER <= 0:
		var instance: Node2D = scene.instantiate()
		get_parent().get_parent().add_child(instance)
		instance.global_position = global_position
		current_distance += distance
		print("spawn")
