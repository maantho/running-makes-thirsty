class_name Level
extends Node

const PIXEL_PER_METER: float = 70
const BASE_SPEED: float = 6
const MILESTONES: Array[int] = [10, 50, 100, 500, 1000, 3000, 5000, 10000, 21000, 42000, 100000]

const DRINK_SPEED: float = 50
const WATER_REDUCTION: float = 5
const ALKOHOL_REDUCTION: float = 5
const SUGAR_REDUCTION: float = 0.5
const ADDITIONAL_REDUCTION:float = 0.001
const MAX_TOTRAL_FILL: float = 500

var current_milestone: int = 0

var current_speed: float = 1
var current_weight: float = 0

var current_additional_reduction: float = 0
var current_water: float = 200
var current_alkohol: float = 0
var current_sugar: float = 0
var current_total_fill: float = 200

@onready var bag: Bag = %Bag
@onready var player: Node2D = %Player
@onready var mouth: Mouth = %Mouth

@onready var hydration_progress: TextureProgressBar = %HydrationProgress
@onready var level_progress: TextureProgressBar = %LevelProgress
@onready var milestone_label: Label = %MilestoneLabel
@onready var speed_label: Label = %SpeedLabel
@onready var sugar_label: Label = %SugarLabel
@onready var drunkeness_label: Label = %DrunkenessLabel
@onready var weightlabel: Label = %Weightlabel


func _ready() -> void:
	bag.added.connect(_added_to_bag)
	bag.removed.connect(_removed_from_bag)
	
	current_total_fill = current_water + current_alkohol + current_sugar
	hydration_progress.max_value = MAX_TOTRAL_FILL
	hydration_progress.value = current_total_fill
	
	level_progress.max_value = MILESTONES[current_milestone]
	level_progress.value = 0
	milestone_label.text = str(MILESTONES[current_milestone]) + "m"


func _process(delta: float) -> void:
	if mouth.bottle:
		var chuck: Chuck = mouth.bottle.empty(DRINK_SPEED, delta)
		var total_chuck: float = chuck.water + chuck.alkohol + chuck.sugar
		var to_be_filled: float = MAX_TOTRAL_FILL - current_total_fill
		var wanted_value: float = clampf(to_be_filled / total_chuck, 0, 1)
		
		current_water += chuck.water * wanted_value
		current_alkohol += chuck.alkohol * wanted_value
		current_sugar += chuck.sugar * wanted_value
		
		chuck.water *= 1 - wanted_value
		chuck.alkohol *= 1 - wanted_value
		chuck.sugar *= 1 - wanted_value
		
		mouth.bottle.return_chuck(chuck)
	
	current_additional_reduction += ADDITIONAL_REDUCTION * delta
	
	current_water = maxf(current_water - WATER_REDUCTION * delta - current_additional_reduction, 0)
	current_alkohol = maxf(current_alkohol - ALKOHOL_REDUCTION * delta - current_additional_reduction, 0)
	current_sugar = maxf(current_sugar - SUGAR_REDUCTION * delta - current_additional_reduction, 0)
	
	current_total_fill = current_water + current_alkohol + current_sugar
	hydration_progress.value = current_total_fill
	
	if current_total_fill <= 0:
		print("gameover")
		var scene = load("res://menu/game_over_menu.tscn").instantiate()
		get_tree().root.add_child(scene)
		scene.set_score(str(round(player.global_position.x / PIXEL_PER_METER)) + "m")
		get_tree().current_scene = scene
		queue_free()
		#get_tree().change_scene_to_file("res://menu/game_over_menu.tscn")



func _physics_process(delta: float) -> void:
	current_speed = BASE_SPEED + current_sugar * 0.05 - current_alkohol * 0.01 - current_weight * 0.001
	
	speed_label.text = str(_round_to_dec(current_speed, 1)) + "m/s"
	sugar_label.text = str(roundi(current_sugar)) + "g"
	drunkeness_label.text = str(roundi(current_alkohol)) + "g"
	weightlabel.text = str(roundi(current_weight)) + "g"
	
	
	player.global_position.x += PIXEL_PER_METER * current_speed * delta
	level_progress.value = player.global_position.x / PIXEL_PER_METER
	if level_progress.value >= level_progress.max_value:
		current_milestone += 1
		level_progress.max_value = MILESTONES[current_milestone]
		milestone_label.text = str(MILESTONES[current_milestone]) + "m"


func _added_to_bag(entity: Entity) -> void:
	#adjust weight
	current_weight += entity.get_weight()


func _removed_from_bag(entity: Entity) -> void:
	#adjust weigth
	current_weight -= entity.get_weight()


func _round_to_dec(num, digit) -> float:
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
