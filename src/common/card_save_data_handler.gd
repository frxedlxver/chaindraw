class_name CardSaveDataHandler

static var card_scene : PackedScene = preload("res://assets/pfbs/card.tscn")

const save_data_directory : String = "user://savedata/"
const deck_path : String = "user://savedata/deck.res"


static func load_deck():
	var deck_data_resource = ResourceLoader.load(deck_path)
	
	# Check if the loaded resource is non-null and is of the expected type
	if deck_data_resource and deck_data_resource is DeckSaveData:
		var deck_data : DeckSaveData = deck_data_resource as DeckSaveData
		var deck : Deck = Deck.new()
		
		for card in load_deck_from_save_data(deck_data):
			deck.add_card(card)
		
		return deck
	else:
		print("Failed to load deck data or wrong resource type.")
		return null
	
static func save_deck(deck_to_save : Deck):
	var deck_data : DeckSaveData = DeckSaveData.new()
	
	if !DirAccess.dir_exists_absolute(save_data_directory):
		DirAccess.make_dir_absolute(save_data_directory)
	
	deck_data.extract_data_from_deck(deck_to_save)
	
	ResourceSaver.save(deck_data, deck_path)
	
static func load_card_from_save_data(card_save_data : CardSaveData) -> CardNode:
	var card : CardNode = card_scene.instantiate()
	var card_base = load(card_save_data.logic_script_path).new(card_save_data.id)
	card.card_base = card_base
	return card


static func load_deck_from_save_data(deck_save_data : DeckSaveData) -> Array:
	var cards : Array[CardNode] = []
	var highest_loaded_id : int = 0
	
	for card_data : CardSaveData in deck_save_data.cards:
		var card : CardNode = load_card_from_save_data(card_data)
		cards.append(card)
		if card.card_base.id > highest_loaded_id:
			highest_loaded_id = card.card_base.id
	
	CardFactory.update_next_id_after_load(highest_loaded_id)
	return cards
