extends Node2D

const HEXAGON_SCENE_PATH = "res://HexaSprite.tscn"
const ROW_COUNT = 10
const COLUMN_COUNT = 10
const ROW_OFFSET = 44
const OFFSET = Vector2(88, 73)
const START_HEXA_COORD = Vector2(50, 50)
const NUMBER_OF_FIELDS = COLUMN_COUNT * ROW_COUNT
const NUMBER_OF_PLAYERS = 2
const NUMBER_OF_DICES = NUMBER_OF_FIELDS * 3
const MAX_FIELD_DICE_NUMBER = 8

var field_array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	#hexagon.set_color(Global.player_color)
	#hexagon.position.x = 100
	
	create_GameField()
	divide_fields()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func divide_fields():
	var player_dice_array = [NUMBER_OF_DICES, NUMBER_OF_DICES]
	
	for field in field_array:
		if player_dice_array[0] == 0:
			field.set_color(Global.player_colors[1])
			set_field_dices(field, player_dice_array[1])
		elif player_dice_array[1] == 0:
			field.set_color(Global.player_colors[0])
			set_field_dices(field, player_dice_array[0])
		else:
			var random_player_index = get_random_integer(0,1)
			set_player_color(field, random_player_index)
			set_field_dices(field, player_dice_array[random_player_index])
			
func set_field_dices(field, player_dice_number):
	var random_dice_number = get_random_integer(1, MAX_FIELD_DICE_NUMBER)
	field.set_text(String(random_dice_number))
	field.dice_number = player_dice_number - random_dice_number
			
func set_player_color(field, random_player_index):
	field.set_color(Global.player_colors[random_player_index])

func get_random_integer(low_range, upper_range):
	var generator = RandomNumberGenerator.new()
	generator.randomize()
	return generator.randi_range(low_range, upper_range) 

func create_GameField():
	var scene = preload(HEXAGON_SCENE_PATH)
	var aggregated_offset = Vector2(0, 0)
	
	for i in range(0, ROW_COUNT - 1):
		var new_y = START_HEXA_COORD.y + aggregated_offset.y
		
		if i % 2 == 1:
			aggregated_offset.x = 0
		else:
			aggregated_offset.x = ROW_OFFSET
		
		for j in range(0, COLUMN_COUNT - 1):
			var new_x = START_HEXA_COORD.x + aggregated_offset.x
			
			var instance = create_instance(scene)
			place_hexagon_tile(scene, instance, new_x, new_y)
			set_instance_coordinates(instance, i, j)
			aggregated_offset.x += OFFSET.x
			
		aggregated_offset.y += OFFSET.y

func place_hexagon_tile(scene, instance, x, y):
	instance.position.x = x
	instance.position.y = y
	return instance
	
func create_instance(scene):
	var instance = scene.instance()
	add_child(instance)
	
	field_array.append(instance)
	
	return instance
	
func set_instance_coordinates(instance, i, j):
	instance.coordinate = Vector2(i, j)
