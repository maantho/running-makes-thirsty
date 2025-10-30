extends Control

@onready var score_label: Label = $ScoreLabel

func set_score(score: String) -> void:
	score_label.text = score


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/main_menu.tscn")
