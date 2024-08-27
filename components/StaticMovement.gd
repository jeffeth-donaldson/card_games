extends Node
# Component for handling moving static bodies
# Allows for multiple different kinds of movement
class_name StaticMovementComponent
enum MOVEMENT_KIND {
	UFO,
	BALL
}

const MAX_ADDITIONAL_ROTATION = 0.6

var node:StaticBody3D
var movement_kind:MOVEMENT_KIND
var destination_pos:Vector3
var destination_rotation:Vector3
var duration:float=0.0
var midpoint:float=0.0
var velocity:Vector3
var acceleration:Vector3
var base_rotation:Vector3
var rotational_velocity:Vector3
var additional_rotation:Vector3 = Vector3.ZERO
var in_motion:bool = false



func _init(new_node:StaticBody3D):
	self.node = new_node
	self.destination_pos = node.position
	self.destination_rotation = node.rotation
	self.base_rotation = node.global_rotation
	print()

func set_destination(new_duration:float, new_position:Vector3=self.destination_pos, new_rotation:Vector3=self.destination_rotation):
	self.destination_pos=new_position
	self.destination_rotation=new_rotation
	#self.base_rotation = node.global_rotation
	self.rotational_velocity=(new_rotation-base_rotation)/new_duration
	self.duration = new_duration
	self.midpoint = duration/2.0
	self.acceleration = _calculate_acceleration()*2.0
	self.in_motion = true

func _calculate_acceleration():
	var distance = destination_pos - node.global_position
	return 2*(distance - velocity*duration) / (duration**2)

func process(delta:float):
	if in_motion:
		duration -= delta
		if duration <= 0:
			var distance = destination_pos - node.global_position
			if distance.length_squared() > 0.05:
				velocity = distance/0.1
			else:
				in_motion = false
				duration = 0
				velocity = Vector3.ZERO
				acceleration = Vector3.ZERO
				node.global_position = destination_pos
				node.global_rotation = destination_rotation
				base_rotation = destination_rotation
				return
		elif duration <= 0.05:
			acceleration = Vector3.ZERO
		if duration <= midpoint:
			midpoint = -1
			acceleration = -acceleration
		node.global_position += velocity*delta
		base_rotation += rotational_velocity*delta
		velocity += acceleration*delta

		# Rotate slightly based on velocity direction
		self.additional_rotation = log(self.velocity.length_squared()+1)*-self.velocity.normalized()/5
		node.global_rotation = self.base_rotation
		node.global_rotation.x += clamp(self.additional_rotation.y, -MAX_ADDITIONAL_ROTATION, MAX_ADDITIONAL_ROTATION)
		#node.global_rotation.z += self.additional_rotation.z
		node.global_rotation.y += clamp(self.additional_rotation.x, -MAX_ADDITIONAL_ROTATION, MAX_ADDITIONAL_ROTATION)

		#print(node.global_rotation)
