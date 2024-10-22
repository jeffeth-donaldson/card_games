extends Node3D

class_name CanastaArea

const CANASTA_WIDTH:float = 1.0
const CANASTA_SPEED:float = 1.0

var canastas:Array[Canasta] = []
var model_changed:bool = false

func canasta_sort(a:Canasta, b:Canasta) -> bool:
	if a.card_num == b.card_num:
		return not a.is_finished()
	else:
		return a.card_num < b.card_num

func get_canasta(card_num:int) -> Canasta:
	for canasta in canastas:
		if canasta.card_num == card_num:
			return canasta
		elif canasta.card_num > card_num:
			# Canastas are sorted so if we get
			# to one that is bigger we can quit
			return null
	# All canastas are smaller
	return null

func add_canasta(canasta:Canasta):
	# Does not check to see if canasta is valid
	# This allows for staging canastas
	canastas.append(canasta)
	canastas.sort_custom(canasta_sort)
	model_changed = true


func _process(delta: float) -> void:
	if model_changed:
		#Reorder Canastas
		var width = CANASTA_WIDTH*len(canastas)
		var canasta_pos = -width/2 # Make Centerpoint 0
		for canasta in canastas:
			canasta.movement_component.set_destination(CANASTA_SPEED, Vector3(canasta_pos, 0, 0))
			canasta_pos += CANASTA_WIDTH
		model_changed = false
