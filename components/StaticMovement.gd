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
var base_rotation:Vector3 = Vector3.ZERO
var additional_rotation:Vector3 = Vector3.ZERO



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
			
			# Rotate slightly based on velocity direction
			self.additional_rotation = log(self.velocity.length_squared()+1)*-self.velocity.normalized()/5
			node.global_rotation = self.base_rotation
			node.global_rotation.x += self.additional_rotation.y
			#node.global_rotation.z += self.additional_rotation.z
			node.global_rotation.y += self.additional_rotation.x
			
			#print(node.global_rotation)
			
			node.global_position += velocity*delta

