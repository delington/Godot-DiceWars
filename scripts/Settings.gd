extends Control

const WELCOME_SCREEN_SCENE_PATH = "res://scenes/WelcomeScreen.tscn"

onready var row_count_input = $"%RowInputText"
onready var column_count_input = $"%ColumnInputText"
onready var is_blank_checkbox = $"%CheckBox" as CheckBox

# Called when the node enters the scene tree for the first time.
func _ready():
	row_count_input.set_text(str(Global.settings.row_count))
	column_count_input.set_text(str(Global.settings.column_count))

func _on_ApplyButton_pressed():
	Global.settings.row_count = row_count_input.get_text() as int
	Global.settings.column_count = column_count_input.get_text() as int
	Global.settings.has_blank_fields = is_blank_checkbox.is_pressed()
	
	get_tree().change_scene(WELCOME_SCREEN_SCENE_PATH)
