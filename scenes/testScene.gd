extends Node3D

const cards:= []
const ROTATION_SPEED = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	var mytheme = CardThemeModel.new()
	mytheme.backPath = "res://assets/Cards Pack/PNG/Large/Back Blue 1.png"
	mytheme.frontPath = "res://assets/Cards Pack/PNG/Large/"
	var myCardModel = CardModel.new()
	myCardModel.card_num = 5
	myCardModel.theme = mytheme
	var myCard = Card.new()
	myCard.card_model = myCardModel
	add_child(myCard)
	cards.append(myCard)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	for card in cards:
		card.rotate_x(delta*ROTATION_SPEED)
