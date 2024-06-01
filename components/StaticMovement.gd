extends Node
# Component for handling moving static bodies
# Allows for multiple different kinds of movement
class_name StaticMovementComponent
enum MOVEMENT_KIND {
	UFO,
	BALL
}

var node:StaticBody3D
var movement_kind:MOVEMENT_KIND
var destination_pos:Vector3
var destination_rotation:Vector3
var duration:float=0.0
var midpoint:float=0.0
var velocity:Vector3
var acceleration:Vector3

func _init(node:StaticBody3D):
	self.node = node
	self.destination_pos = node.global_position
	self.destination_rotation = node.rotation
	
func set_destination(duration:float, position:Vector3=self.destination_pos, rotation:Vector3=self.destination_rotation):
	self.destination_pos=position
	self.destination_rotation=rotation
	self.duration = duration
	self.midpoint = duration/2
	self.acceleration = _calculate_acceleration()*2

func _calculate_acceleration():
	var distance = destination_pos - node.global_position
	return 2*(distance - velocity*duration) / (duration**2)

func process(delta:float):
	if duration > 0:
		duration -= delta 
		if duration <= 0:
			duration = 0
			velocity = Vector3.ZERO
			acceleration = Vector3.ZERO
			node.position = destination_pos
			node.rotation = destination_rotation
		else:
			if duration <= midpoint:
				midpoint = -1
				acceleration = -acceleration
			velocity += acceleration*delta
			node.translate(velocity*delta)

