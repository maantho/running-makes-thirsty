class_name Entity
extends RigidBody2D

signal grabbed(entity: Entity)
signal dropped(entity: Entity)

@export var base_weight: float = 50

var under_mouse: bool = false
var dragging: bool = false
var offset: Vector2 = Vector2.ZERO
var used: bool = false


func _init() -> void:
	input_pickable = true
	can_sleep = false
	freeze_mode = FREEZE_MODE_KINEMATIC
	freeze = true
	collision_layer = 0
	set_collision_layer_value(1, true)
	collision_mask = 0
	
	z_as_relative = false
	z_index = -50


func _mouse_enter() -> void:
	under_mouse = true


func _mouse_exit() -> void:
	under_mouse = false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("click") and under_mouse and Mouse.dragged_object == null:
		Mouse.dragged_object = self
		dragging = true
		offset = global_position - get_global_mouse_position()
		
		freeze = true
		
		collision_layer = 0
		set_collision_layer_value(3, true)
		collision_mask = 0
		
		_set_z_ordering()
		
		grabbed.emit(self)
	
	if dragging:
		global_position = get_global_mouse_position() + offset
	
	if Input.is_action_just_released("click") and dragging:
		Mouse.dragged_object = null
		dragging = false
		
		freeze = false
		
		collision_layer = 0
		set_collision_layer_value(2, true)
		collision_mask = 0
		set_collision_mask_value(2, true)
		
		dropped.emit(self)


func _set_z_ordering() -> void:
	z_index = 0


func get_weight() -> float:
	return base_weight
