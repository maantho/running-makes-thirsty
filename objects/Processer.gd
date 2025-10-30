class_name Processer
extends Entity

enum EmptyingType {JUICY, CITRUS, BOTTLE}
@export var type: EmptyingType

@export var speed: float = 10

@export var filling_bottle_remote: RemoteTransform2D
@export var emptying_food_remote: RemoteTransform2D

var filling_bottle: Bottle
var emptying_food: Food

func _process(delta: float) -> void:
	super._process(delta)
	if filling_bottle and emptying_food:
		var chuck: Chuck = emptying_food.empty(speed, delta)
		chuck = filling_bottle.fill(chuck)
		emptying_food.return_chuck(chuck)

func _on_body_entered(body: Node2D) -> void:
	var  new_bottle := body as Bottle
	if new_bottle and !filling_bottle:
		if !new_bottle.dropped.is_connected(_add_filling_bottle):
			new_bottle.dropped.connect(_add_filling_bottle)
	
	if type == EmptyingType.BOTTLE:
		if new_bottle and !emptying_food:
			if !new_bottle.dropped.is_connected(_add_emptying_food):
				new_bottle.dropped.connect(_add_emptying_food)
	else:
		var new_fruit := body as Fruit
		if new_fruit and !emptying_food:
			if type == EmptyingType.CITRUS:
				if new_fruit.type == new_fruit.TypeEnum.CITRUS:
					if !new_fruit.dropped.is_connected(_add_emptying_food):
						new_fruit.dropped.connect(_add_emptying_food)
			if type == EmptyingType.JUICY:
				if new_fruit.type == new_fruit.TypeEnum.JUICY:
					if !new_fruit.dropped.is_connected(_add_emptying_food):
						new_fruit.dropped.connect(_add_emptying_food)


func _on_body_exited(body: Node2D) -> void:
	var  new_bottle := body as Bottle
	if new_bottle and !filling_bottle:
		if new_bottle.dropped.is_connected(_add_filling_bottle):
			new_bottle.dropped.disconnect(_add_filling_bottle)
	
	if type == EmptyingType.BOTTLE:
		if new_bottle and !emptying_food:
			if new_bottle.dropped.is_connected(_add_emptying_food):
				new_bottle.dropped.disconnect(_add_emptying_food)
	else:
		var new_fruit := body as Fruit
		if new_fruit and !emptying_food:
			if type == EmptyingType.CITRUS:
				if new_fruit.type == new_fruit.TypeEnum.CITRUS:
					if new_fruit.dropped.is_connected(_add_emptying_food):
						new_fruit.dropped.disconnect(_add_emptying_food)
			if type == EmptyingType.JUICY:
				if new_fruit.type == new_fruit.TypeEnum.JUICY:
					if new_fruit.dropped.is_connected(_add_emptying_food):
						new_fruit.dropped.disconnect(_add_emptying_food)


func _add_filling_bottle(new_bottle: Bottle) -> void:
	if not new_bottle.used:
		filling_bottle = new_bottle
		filling_bottle.used = true
		filling_bottle.collision_layer = 0
		filling_bottle.set_collision_layer_value(3, true)
		filling_bottle.collision_mask = 0
		add_collision_exception_with(filling_bottle)
		filling_bottle.freeze = true
		filling_bottle.grabbed.connect(_remove_filling_bottle)
		filling_bottle_remote.remote_path = filling_bottle.get_path()
		print("filling bottle added")

func _remove_filling_bottle(old_bottle: Bottle) -> void:
	filling_bottle = null
	old_bottle.used = false
	remove_collision_exception_with(old_bottle)
	old_bottle.grabbed.disconnect(_remove_filling_bottle)
	filling_bottle_remote.remote_path = ""
	print("filling bottle removed")


func _add_emptying_food(new_Food: Food) -> void:
	if not new_Food.used:
		emptying_food = new_Food
		emptying_food.used = true
		emptying_food.collision_layer = 0
		emptying_food.set_collision_layer_value(3, true)
		emptying_food.collision_mask = 0
		add_collision_exception_with(emptying_food)
		emptying_food.freeze = true
		emptying_food.grabbed.connect(_remove_emptying_food)
		emptying_food_remote.remote_path = emptying_food.get_path()
		print("emptying food added")
	


func _remove_emptying_food(old_food: Food) -> void:
	emptying_food = null
	old_food.used = false
	remove_collision_exception_with(old_food)
	old_food.grabbed.disconnect(_remove_emptying_food)
	emptying_food_remote.remote_path = ""
	print("emptying food removed")


func _set_z_ordering() -> void:
	z_index = -1
