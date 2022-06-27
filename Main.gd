extends Node2D

const HEXAGON_SCENE = "res://HexaSprite.tscn"
const ROW_COUNT = 5
const COLUMN_COUNT = 10
const OFFSET_X = 88
const OFFSET_Y = 73
const ROW_OFFSET = 44

# Called when the node enters the scene tree for the first time.
func _ready():
	#hexagon.set_color(Global.player_color)
	#hexagon.position.x = 100
	
	create_GameField()
	
	#var area_hexa = $"HexaSprite/AreaHexa"
	#area_hexa.connect("input_event", self, "_on_AreaHexa_input_event")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func create_GameField():
	var scene = preload(HEXAGON_SCENE)
	
	#var instance = hexagon.duplicate()
	#add_child(instance)
	#instance.position.x = 120
	var position_x = 50
	var position_y = 50
	
	var offset_x = 0
	var offset_y = 0
	
	for i in range(ROW_COUNT):
		var new_y = position_y + offset_y
		if i % 2 == 1:
			offset_x = 0
		else:
			offset_x = ROW_OFFSET
		
		for j in range(COLUMN_COUNT):
			var new_x = position_x + offset_x
			place_hexagon_tile(scene, new_x, new_y)
			offset_x += OFFSET_X
			
		offset_y += OFFSET_Y
	
	 #print(str("WIDTH ---> ", instance.get_rect()))

func place_hexagon_tile(scene, x, y):
	var instance = scene.instance()
	add_child(instance)
	instance.position.x = x
	instance.position.y = y
