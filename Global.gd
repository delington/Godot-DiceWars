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
const player_colors = [player_colors_dict[0]["value"], player_colors_dict[1]["value"]]
const FIRST_PLAYER_INDEX = 0
const SECOND_PLAYER_INDEX = 1
const OPTION_BUTTON_PLAYER_KEY = "selected_player"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
