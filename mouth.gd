class_name Mouth
extends Area2D

var bottle: Bottle

@onready var remote_transform_2d: RemoteTransform2D = $RemoteTransform2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	var  new_bottle := body as Bottle
	if new_bottle and !bottle:
		if !new_bottle.dropped.is_connected(_add_bottle):
			new_bottle.dropped.connect(_add_bottle)


func _on_body_exited(body: Node2D) -> void:
	var  new_bottle := body as Bottle
	if new_bottle and !bottle:
		if new_bottle.dropped.is_connected(_add_bottle):
			new_bottle.dropped.disconnect(_add_bottle)


func _add_bottle(new_bottle: Bottle) -> void:
	if not new_bottle.used:
		bottle = new_bottle
		bottle.used = true
		bottle.freeze = true
		new_bottle.grabbed.connect(_remove_bottle)
		remote_transform_2d.remote_path = bottle.get_path()

func _remove_bottle(old_bottle: Bottle) -> void:
	bottle = null
	old_bottle.used = false
	old_bottle.grabbed.disconnect(_remove_bottle)
	remote_transform_2d.remote_path = ""
