extends Sprite

var color = Global.player_color
var selected = false
var coordinate

# Called when the node enters the scene tree for the first time.
func _ready():
	set_color(Global.player_color)
	#self.position.x = 100
	
	var area_hexa = $"AreaHexa"
	area_hexa.connect("input_event", self, "_on_AreaHexa_input_event")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#self.modulate = color
	pass

func set_color(new_color):
	self.modulate = new_color
	
func _on_AreaHexa_input_event(viewport, event, shape_idx):
	
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if selected:
			selected = false
			#self.color = Global.player_color
			set_color(Global.player_color)
		else: 
			selected = true
			#self.color = Global.selection_color
			set_color(Global.selection_color)
