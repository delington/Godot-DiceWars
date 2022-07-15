extends Control

signal change_scene()

onready var option_button = $"OptionButton"

var parameters = {
	Global.OPTION_BUTTON_PLAYER_KEY: -1
}


# Called when the node enters the scene tree for the first time.
func _ready():
	var player_colors = Global.player_colors_dict
	
	for i in range(0, player_colors.size()):
		option_button.add_item(player_colors[i]["text"])


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Button_pressed():
	parameters[Global.OPTION_BUTTON_PLAYER_KEY] = option_button.get_selected_id()
	emit_signal("change_scene")
