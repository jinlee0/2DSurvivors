extends PanelContainer
class_name AbilityUpgradeCard

signal selected

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var hover_animation: AnimationPlayer = $HoverAnimationPlayer


func _ready():
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)


func play_in():
	animation.play("in")


func play_discard():
	animation.play("discard")


func disable():
	gui_input.disconnect(on_gui_input)
	mouse_entered.disconnect(on_mouse_entered)
	hover_animation.play("RESET")
	animation.play("RESET")


func on_gui_input(event: InputEvent):
	if not event.is_action_pressed("left_click"): return
	
	var signals = Signals.new()
	for card in NodeGroup.get_upgrade_cards(get_tree()):
		card.disable()
		if card == self: 
			animation.play("select")
		else:
			card.play_discard()
		signals.append(card.animation.animation_finished)
	
	await signals.await_all()
	selected.emit()


func set_ability_upgrade(upgrade: PlayerAbility):
	name_label.text = upgrade.name
	description_label.text = upgrade.description


func on_mouse_entered():
	hover_animation.play("hover")
