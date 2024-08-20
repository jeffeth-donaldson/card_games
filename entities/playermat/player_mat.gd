extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#visible = false
	return

@export var my_material: Material:
	set(value):
		$MeshInstance3D.mesh.material = value
	get():
		return $MeshInstance3D.mesh.material
