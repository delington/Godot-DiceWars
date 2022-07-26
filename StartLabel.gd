extends Label

const TURN_LABEL = "'s turn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_text_and_color(player_index) -> void:
	var opponent_object = Global.player_colors_dict[player_index]
	var opponent_color: String = opponent_object.text
	self.text = str(opponent_color, TURN_LABEL)
	self.add_color_override("font_color", opponent_object.value)
