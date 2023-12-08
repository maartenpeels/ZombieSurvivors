extends PanelContainer

signal upgrade_selected

@onready var name_label: Label = $%NameLabel
@onready var desc_label: Label = $%DescriptionLabel


func set_ability_upgrade(upgrade: AbilityUpgrade):
	name_label.text = upgrade.name
	desc_label.text = upgrade.description


func _on_gui_input(event: InputEvent):
	if event.is_action_pressed("left_click"):
		upgrade_selected.emit()
