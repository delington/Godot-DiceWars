extends Node2D

const selection_color = Color.white
const player_colors_dict = [
	{
		"text": "Blue",
		"value": Color.blue
	},
	{
		"text": "Red",
		"value": Color.red
	}
]
const FIRST_PLAYER_INDEX = 0
const SECOND_PLAYER_INDEX = 1
const OPTION_BUTTON_PLAYER_KEY = "selected_player"

var ref: Dictionary

var current_player_index: int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_player_color_value_by_index(index):
	return player_colors_dict[index]["value"]
	
func get_player_color_name_by_index(index):
	return player_colors_dict[index]["text"]
