extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/games/hand_and_foot/hand_and_foot.tscn")


func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/games/options/options.tscn")


func _on_quit_pressed():
	get_tree().quit()
