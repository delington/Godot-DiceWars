extends Sprite

var color = null
var text = ""
var selected = false
var dice_number = 0
var coordinate = Vector2()
onready var label_node = $"Label"

# Called when the node enters the scene tree for the first time.
func _ready():
	#set_color(color)
	
	var area_hexa = $"AreaHexa"
	area_hexa.connect("input_event", self, "_on_AreaHexa_input_event")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#self.modulate = color
	pass

func set_text(new_text):
	self.text = new_text
	label_node.text = new_text

func set_color(new_color):
	self.color = new_color
	self.modulate = new_color
	
func _on_AreaHexa_input_event(viewport, event, shape_idx):
	
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if selected:
			selected = false
			set_color(color)
		else: 
			selected = true
			self.modulate = Global.selection_color
			self.modulate.a = 5
