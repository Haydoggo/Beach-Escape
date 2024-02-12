class_name UnitButton extends MarginContainer

signal pressed

@onready var button_label: Label = %ButtonLabel
@onready var button: BaseButton = $Button
@onready var button_icon: TextureRect = %ButtonIcon

var text : String:
	set(v):
		text = v
		button_label.text = text
var icon : Texture:
	set(v):
		icon = v
		button_icon.texture = icon
var shortcut_keycode : int:
	set(v):
		shortcut_keycode = v
		shortcut_event.keycode = shortcut_keycode as Key
		$NumberKeyLabel.text = str(v-48)
var unit_count : UnitCount
var shortcut_event : InputEventKey

func _ready() -> void:
	button.shortcut = Shortcut.new()
	
	shortcut_event = InputEventKey.new()
	button.shortcut.events.append(shortcut_event)	
	button.pressed.connect(func():pressed.emit())

