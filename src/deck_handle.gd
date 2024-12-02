
# class to separate main deck from battle deck
class_name DeckHandle extends Control


@export var count_label : Label

var cards : Array[CardNode]

var card_count : int: 
	get: return cards.size()
var card_count_str : String:
	get: return str(card_count)

signal is_empty()
signal shuffled()
signal card_drawn(card : CardNode)
signal card_added(card : CardNode)

func on_battle_start(deck : Deck):
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
		is_empty.emit()
	
	update_visuals()
	
	if card_to_return:
		card_drawn.emit(card_to_return)
		return card_to_return
		
func find_card_by_id(target_id : int):
	for card in cards:
		if card.card_base.id == target_id:
			cards.erase(card)
			return card
	return null

func add_to_deck(card : CardNode):
	cards.append(card)
	card_added.emit()
	update_visuals()

func add_to_deck_and_shuffle(card : CardNode):
	add_to_deck(card)
	shuffle()

func add_to_deck_at_bottom(card : CardNode):
	cards.push_back(card)
	card_added.emit()
	update_visuals()

func add_to_deck_at_top(card : CardNode):
	cards.push_front(card)
	card_added.emit()
	update_visuals()

func update_visuals():
	count_label.text = card_count_str

func shuffle():
	# may add visual component later
	cards.shuffle()
	shuffled.emit()
