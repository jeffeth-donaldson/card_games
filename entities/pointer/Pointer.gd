extends Node3D

class_name Pointer
# Class to handle the mouse interacting with the 3D world.
# Each frame it checks to see if the mouse cursor is hovering over a Node.
# If so, it will call the on_hover function of the Node if it has a hoverable component
# On the next frame, if the mouse is not over the previous hoverable, 
# it will call the on_leave function.
var last_hoverable:Node3D

func _get_mouse_collision():
	var viewport := get_viewport()
	var mouse_position := viewport.get_mouse_position()
	var camera := viewport.get_camera_3d()
	
	var origin := camera.project_ray_origin(mouse_position)
	var direction := camera.project_ray_normal(mouse_position)
	var ray_length := camera.far
	var end := origin + direction * ray_length
	
	var space_state := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(origin, end)
	var result := space_state.intersect_ray(query)

	return result
	

func _physics_process(delta):
	var collision = _get_mouse_collision()
	
	#if "position" in collision and collision["position"] != null:
		#print(collision["position"])
	
	if "collider" in collision and collision["collider"] != null:
		if last_hoverable != null and collision["collider"] != last_hoverable:
			last_hoverable.hoverable_component.call_on_leave(collision["position"])
			last_hoverable = collision["collider"]
		#print(collision["collider"])
		if "hoverable_component" in collision["collider"]:
			collision["collider"].hoverable_component.call_on_hover(collision["position"])
			last_hoverable = collision["collider"]
			#print("i'm hoverable!")
	elif last_hoverable != null:
		print("no longer hovering")
		last_hoverable.hoverable_component.call_on_leave(collision.get("position", Vector3.ZERO))
		last_hoverable = null
	
