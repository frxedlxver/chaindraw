class_name StatusUIDev extends PanelContainer

@export var status_node_container  : Control

var status_node_pfb : PackedScene = preload("res://assets/pfbs/status_ui.tscn")

func statuses_updated(statuses : Array):
	for child in status_node_container.get_children():
		status_node_container.remove_child(child)
		child.queue_free()
	
	for status : StatusEffect in statuses:
		var status_node_ui = status_node_pfb.instantiate()
		var stacks = 0;
		if status is StackableStatusEffect:
			stacks = status.stacks
		status_node_ui.get_child(0).get_child(0).text = status.data.name
		status_node_ui.get_child(0).get_child(1).text = str(stacks)
		status_node_container.add_child(status_node_ui)
		
