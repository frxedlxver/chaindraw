class_name BattleUIManager extends Node

@export var deck_display_panel : DeckDisplayPanel

enum BattleUIState {
	NORMAL,
	SHOWING_DECK
}

var state : BattleUIState

signal state_changed(new_state : BattleUIState, old_state : BattleUIState)

func _ready():
	self.state = BattleUIState.NORMAL
	
func _on_deck_handle_clicked(deck : DeckHandle):
	match state:
		BattleUIState.NORMAL:
			deck_display_panel.show()
			deck_display_panel.update_card_display(deck.cards)
			self._change_state(BattleUIState.SHOWING_DECK)

func _input(event : InputEvent):
	match(state):
		BattleUIState.SHOWING_DECK:
			if event.is_action_pressed("ui_cancel"):
				_change_state(BattleUIState.NORMAL)

func _change_state(new_state : BattleUIState):
	match(new_state):
		BattleUIState.NORMAL:
			deck_display_panel.hide()
		BattleUIState.SHOWING_DECK:
			pass

	state_changed.emit(new_state, self.state)
	self.state = new_state
