extends Node

class_name HoverableComponent

var on_hover:Callable
var on_leave:Callable

func _init(new_on_hover:Callable, new_on_leave:Callable):
	on_hover = new_on_hover
	on_leave = new_on_leave

func call_on_hover(point:Vector3):
	if on_hover != null:
		on_hover.call(point)

func call_on_leave(point:Vector3):
	if on_leave  != null:
		on_leave.call(point)
