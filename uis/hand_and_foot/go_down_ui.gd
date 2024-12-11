extends Control

class_name GoDownUI

var total_points:int = 0
var needed_points:int = 0

var points_label:Label = null

func setup(new_needed_points) -> void:
	needed_points = new_needed_points
	update_message()
	visible = true

func edit_points(new_points:int) -> void:
	total_points = new_points
	update_message()

func update_message() -> void:
	if points_label != null:
		points_label.text = "Points to go down: " + str(total_points) + "/" + str(needed_points)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	points_label = $Points


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
