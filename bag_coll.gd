extends AnimatableBody2D

@onready var node_2d: Node2D = $"../PlayerGraphics/polygons/Pants/UpperBody"

func _physics_process(delta: float) -> void:
	global_position = node_2d.global_position
	global_rotation = lerp(global_rotation, node_2d.global_rotation, 0.7)
