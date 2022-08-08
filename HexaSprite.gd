extends Sprite

const PLAYER_PREFIX = "player_"

signal signal_select_field(instance)

var color: Color
var text: String = ""
var selected = false
var dice_number = 0
var coordinate = Vector2()
onready var label_node = $"Label"
var select_chance = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#set_color(color)
	
	var area_hexa = $"AreaHexa"
	area_hexa.connect("input_event", self, "_on_AreaHexa_input_event")
	self.connect("signal_select_field", Global.ref["Battlefield"], "handle_battle")

func set_group(player_index: int):
	add_to_group(str(PLAYER_PREFIX, player_index))
	
func remove_group(player_index: int):
	remove_from_group(str(PLAYER_PREFIX, player_index))

func set_text(new_text: String):
	self.text = new_text
	label_node.text = new_text

func set_color(new_color: Color):
	self.color = new_color
	self.modulate = new_color
	
func set_dice_number(new_dice_number):
	self.dice_number = new_dice_number
	set_text(new_dice_number as String)
	
func set_unselected():
	self.selected = false
	self.set_color(self.color)
	
func set_selected():
	self.selected = true
	self.modulate = Global.selection_color
	self.modulate.a = 5
	
func _on_AreaHexa_input_event(viewport, event, shape_idx):
	
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		emit_signal("signal_select_field", self)
