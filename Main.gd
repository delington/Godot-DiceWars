extends Node2D

const HEXAGON_SCENE_PATH = "res://HexaSprite.tscn"
const ROW_COUNT = 10
const COLUMN_COUNT = 10
const ROW_OFFSET = 44
const OFFSET = Vector2(88, 73)
const START_HEXA_COORD = Vector2(50, 50)

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
	var scene = preload(HEXAGON_SCENE_PATH)
	
	#var instance = hexagon.duplicate()
	#add_child(instance)
	#instance.position.x = 120
	
	var offset_x = 0
	var offset_y = 0
	
	for i in range(0, ROW_COUNT - 1):
		var new_y = START_HEXA_COORD.y + offset_y
		
		if i % 2 == 1:
			offset_x = 0
		else:
			offset_x = ROW_OFFSET
		
		for j in range(0, COLUMN_COUNT - 1):
			var new_x = START_HEXA_COORD.x + offset_x
			
			var instance = create_instance(scene)
			place_hexagon_tile(scene, instance, new_x, new_y)
			set_instance_coordinates(instance, i, j)
			offset_x += OFFSET.x
			
		offset_y += OFFSET.y

func place_hexagon_tile(scene, instance, x, y):
	instance.position.x = x
	instance.position.y = y
	return instance
	
func create_instance(scene):
	var instance = scene.instance()
	add_child(instance)
	return instance
	
func set_instance_coordinates(instance, i, j):
	instance.coordinate = Vector2(i, j)
