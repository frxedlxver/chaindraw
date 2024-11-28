class_name DeckHandle extends Control

var deck : Deck
@export var count_label : Label

var cards : Array[CardWithID]
var card_count : int : 
	get: return cards.size()
var card_count_str : String:
	get: return str(card_count)

signal deck_empty()

func _ready() -> void:
	self.deck = DebugDeckLoader.get_deck()

func on_battle_start():
	cards.assign(deck.get_cards())
	cards.shuffle()
	update_visuals()
	
func draw_from_top():
	print("drawing from deck size %s" % card_count_str)
	var card_to_return
	if card_count > 0:
		card_to_return = cards.pop_back()
	print("card count after drawing %s" % card_count_str)
	
	if card_count == 0:
		deck_empty.emit()
	
	update_visuals()
	if card_to_return:
		return card_to_return
	

func update_visuals():
	count_label.text = card_count_str
	
