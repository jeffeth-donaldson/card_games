extends Node3D

const DEAL_CARDS_COOLDOWN:float = 0.5

const SCORES_TO_GO_DOWN:=[50,90,120,150]

const WILD_CARDS:Array[int]=[2,13]

enum GameState {
	NEW_HAND,
	DEAL,
	ROUND,
	TALLY_POINTS,
	FINISHED
}

var players:Array[HFPlayer]
var deck:Deck
var discard:Deck
var mats:Array[Node3D]
var footmats:Array[Node3D]
var _mytheme = CardThemeModel.new(
	"Test Theme",
	"res://assets/Cards Pack/PNG/Large/Back Blue 1.png",
	"res://assets/Cards Pack/PNG/Large/"
)
# Variables for GameState.NEW_HAND
var new_round:bool=false
var deck_initialized:bool=false
var new_round_timer:float
var current_game_state:GameState = GameState.NEW_HAND
# Variables for GameState.ROUND
var round:int=0
var current_player:int=0
var needs_setup:bool=true


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

func deal_out_cards():
		# Deal out cards
	for i in range(13*8):
		# Deal out to each player's hand, and then the foot
		var player = i%4
		if i%8 > 3:
			players[player].hand.add_cards(deck.draw())
		else:
			players[player].foot.add_cards(deck.draw())

func initialize_new_round():
	for i in range(len(players)):
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
		players[i].foot.global_position = footmats[i].global_position
		players[i].foot.global_rotation = footmats[i].global_rotation

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
	new_round_timer = DEAL_CARDS_COOLDOWN
	deck_initialized = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	players = []
	mats = [$PlayerMat,$PlayerMat2,$PlayerMat3,$PlayerMat4]
	footmats = [$FootMat1,$FootMat2,$FootMat3,$FootMat4]
	for i in range(4):
		# first thing is team, there are 2 teams, second is is_human, for now only player 0 is human
		# Lastly, is player is if the player is the player playing the game on this screen
		# Only player 0 is this player
		players.append(HFPlayer.new(i % 2, i==0, i==0))
	new_round = true



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match current_game_state:
		GameState.NEW_HAND:
			if !deck_initialized:
				initialize_new_round()
			elif new_round_timer > 0:
				new_round_timer -= delta
			else:
				current_game_state = GameState.DEAL
				deck_initialized=false
				deal_out_cards()
		GameState.DEAL:
			if players.all(func(person):
				return person.hand.done_moving()
				):
					current_game_state = GameState.ROUND
		GameState.ROUND:
			if current_player >= len(players):
				current_player = 0
			if players[current_player].player:
				if needs_setup:
					var temp_zone = CanastaArea.new()
					add_child(temp_zone)
					temp_zone.position.y += 1
					players[current_player].hand.onClick = func(card:Card):
						var already_added = true
						var canasta = temp_zone.get_canasta(card.card_model.get_value())
						if canasta == null:
							canasta = Canasta.new(WILD_CARDS)
							already_added = false
						if not canasta.add_cards([card]):
							print("Cannot add card to canasta")
						if not already_added and canasta.card_num > -1:
							temp_zone.add_canasta(canasta)
						players[current_player].hand.remove_card(card)
					needs_setup = false

			elif players[current_player].human:
				# TODO: handle multiplayer player
				pass
			else:
				# TODO: Handle bot player
				pass
			pass
		GameState.TALLY_POINTS:
			#TODO: Implement
			pass
		GameState.FINISHED:
			#TODO: Implement
			pass
