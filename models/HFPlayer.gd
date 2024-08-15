extends Node

class_name HFPlayer

var hand:Hand
var foot:Deck
var team:int
var human:bool
var player:bool

func _init(new_team:int, is_human:bool, is_player:bool) -> void:
	hand = Hand.new()
	foot = Deck.new()
	team = new_team
	human = is_human
	player = is_player
