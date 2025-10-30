class_name Bag
extends Area2D

signal added(entity: Entity)
signal removed(entity: Entity)

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	print("enterd")
	var entity := body as Entity
	if entity:
		added.emit(entity)


func _on_body_exited(body: Node2D) -> void:
	var entity := body as Entity
	if entity:
		removed.emit(entity)
