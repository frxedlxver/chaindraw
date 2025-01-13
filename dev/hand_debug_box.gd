extends PanelContainer

@export var hand : HandNode
@export var deck_handle : DeckHandle
@export var player : Player

var deck : Deck:
	get: return player.deck
