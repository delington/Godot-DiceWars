extends Control

const SETTINGS_SCENE_PATH: String = "res://scenes/Settings.tscn"
const BATTLEFIELD_SCENE_PATH = "res://scenes/Battlefield.tscn"

signal change_to_battlefield_scene()

onready var option_button = $"%OptionButton"


# Called when the node enters the scene tree for the first time.
func _ready():
	OS.window_fullscreen = true
	
	var player_colors = Global.player_colors_dict
	
	for i in range(0, player_colors.size()):
		option_button.add_item(player_colors[i]["text"])


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_StartGameButton_pressed():
	Global.current_player_index = option_button.get_selected_id()
	get_tree().change_scene(BATTLEFIELD_SCENE_PATH)
	

func _on_SettingsButton_pressed():
	get_tree().change_scene(SETTINGS_SCENE_PATH)
