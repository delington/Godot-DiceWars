extends Control

const WELCOME_SCREEN_SCENE_PATH = "res://WelcomeScreen.tscn"

onready var row_count_input = $"%RowInputText"
onready var column_count_input = $"%ColumnInputText"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_ApplyButton_pressed():
	Global.settings.row_count = row_count_input.get_text() as int
	Global.settings.column_count = column_count_input.get_text() as int
	
	#var welcome_screen_scene = preload(WELCOME_SCREEN_SCENE_PATH).instance()
	get_tree().change_scene(WELCOME_SCREEN_SCENE_PATH)
