extends Control
class_name UI

@onready var day_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/DayContainer/DayLabel
@onready var end_day_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/DayContainer/EndDayButton
@onready var inbox_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/InboxContainer/InboxLabel

var DAY = 0
		
func _ready():
	assert(day_label)
	assert(end_day_button)
	_set_end_day_button()
	_update_day_label()
	_set_inbox_label()

func _set_inbox_label():
	inbox_label.text = "Inbox: 0"

func _update_day_label():
	day_label.text = str("Day: ", DAY)
	
func _set_end_day_button():
	end_day_button.text = "End Day"
	end_day_button.pressed.connect(_on_day_end)

func _on_day_end():
	DAY += 1
	_update_day_label()
