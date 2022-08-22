extends Node2D

const selection_color = Color.white
const blank_color = Color.transparent
const FIRST_PLAYER_INDEX = 0
const SECOND_PLAYER_INDEX = 1
const OPTION_BUTTON_PLAYER_KEY = "selected_player"

const DELTA_LIST_OF_NEIGHBOUR_FIELD = {
	"even_rows": [
		Vector2(-1, 0),
		Vector2(-1, 1),
		Vector2(0, -1),
		Vector2(1, 0),
		Vector2(1, 1),
		Vector2(0, 1)
	],
	"odd_rows": [
		Vector2(-1, -1),
		Vector2(-1, 0),
		Vector2(0, -1),
		Vector2(1, -1),
		Vector2(1, 0),
		Vector2(0, 1)
	]
}

var player_colors_dict = [
	{
		"text": "Blue",
		"value": Color.royalblue
	},
	{
		"text": "Red",
		"value": Color.brown
	}
]

var settings = {
	"row_count": 5,
	"column_count": 5,
	"has_blank_fields": false
}

var ref: Dictionary

var current_player_index: int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func get_current_player():
	return player_colors_dict[current_player_index]

func get_player_color_value_by_index(index):
	return player_colors_dict[index]["value"]
	
func get_player_color_name_by_index(index):
	return player_colors_dict[index]["text"]
