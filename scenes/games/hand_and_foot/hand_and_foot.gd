extends Node3D


var players:Array[HFPlayer]
var deck:Deck
var discard:Deck

func hand_and_foot_sort(a:Card, b:Card):
	# Sorts cards according to hand and foot rules
	# Cards 4-8 are 5 pointer cards and are sorted left to right
	# Color does not matter
	# Next comes cards 9-ace which are also sorted in order
	# Next comes 2s which are 20 point wild cards
	# Then comes jokers which are 50 point wild cards
	# Finally comes black threes wich are discards
	# TODO: Implement
	pass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var _mytheme = CardThemeModel.new(
		"Test Theme",
		"res://assets/Cards Pack/PNG/Large/Back Blue 1.png",
		"res://assets/Cards Pack/PNG/Large/"
	)
	players = []
	var mats:Array[Node3D] = [$PlayerMat,$PlayerMat2,$PlayerMat3,$PlayerMat4]
	for i in range(4):
		# first thing is team, there are 2 teams, second is is_human, for now only player 0 is human
		# Lastly, is player is if the player is the player playing the game on this screen
		# Only player 0 is this player
		players.append(HFPlayer.new(i % 2, i==0, i==0))
		# TODO: Use hand and foot sorting algorithm
		players[i].hand = Hand.new(10 if i==0 else 5, hand_and_foot_sort, i==0)
		players[i].foot = Deck.new(DeckModel.Empty())
		add_child(players[i].hand)
		add_child(players[i].foot)
		# Move hand into place
		players[i].hand.global_position = mats[i].global_position
		#players[i].hand.position.x = mats[i].position.x - (players[i].hand.width/2)
		players[i].hand.global_rotation = mats[i].global_rotation
		# Move foot into place
		players[i].hand.add_child(players[i].foot)
		#players[i].foot.position=Vector3(-players[i].hand.MAX_CARD_DISTANCE -0.2, 0,0)
		players[i].foot.global_position = $FootMat1.global_position
		players[i].foot.global_rotation = $FootMat1.global_rotation

	deck = Deck.new(DeckModel.HandAndFoot())
	add_child(deck)
	deck.shuffle()
	discard = Deck.new(DeckModel.Empty())
	add_child(discard)

	deck.global_position = $DrawDeckMat.global_position
	deck.global_rotation = $DrawDeckMat.global_rotation

	discard.global_position = $DiscardDeckMat.global_position
	discard.global_rotation = $DiscardDeckMat.global_rotation

	discard.discard = true

	# Deal out cards
	for i in range(13*8):
		# Deal out to each player's hand, and then the foot
		var player = i%4
		if i%8 > 3:
			players[player].hand.add_cards(deck.draw())
		else:
			players[player].foot.add_cards(deck.draw())
	#myHand = Hand.new()
	#myHand.translate(Vector3(-4,-3,-3))
	#myDeck = Deck.new()
	#myDeck.translate(Vector3(1,0,0))
	#myDeck.rotate_x(90)
	#myDeck.shuffle()
	#add_child(myDeck)
	#add_child(myHand)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
