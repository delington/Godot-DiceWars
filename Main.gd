extends Node2D

const HEXAGON_SCENE_PATH = "res://HexaSprite.tscn"
const ROW_COUNT = 10
const COLUMN_COUNT = 10
const ROW_OFFSET = 44
const OFFSET = Vector2(88, 73)
const START_HEXA_COORD = Vector2(50, 50)
const NUMBER_OF_FIELDS = COLUMN_COUNT * ROW_COUNT
const NUMBER_OF_PLAYERS = 2
const ONE_PLAYER_ALL_FIELDS = NUMBER_OF_FIELDS / 2
const NUMBER_OF_DICES = ONE_PLAYER_ALL_FIELDS * 2
const MAX_FIELD_DICE_NUMBER = 8
const FIRST_PLAYER_INDEX = 0
const SECOND_PLAYER_INDEX = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	#hexagon.set_color(Global.player_color)
	#hexagon.position.x = 100
	
	var field_array = create_game_field()
	set_color_of_fields(field_array)
	set_dices_of_fields(field_array)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_color_of_fields(field_array):
	var field_number_array = [ONE_PLAYER_ALL_FIELDS, ONE_PLAYER_ALL_FIELDS]
	
	for i in range(0, ROW_COUNT):
		for j in range(0, COLUMN_COUNT):
			var random_player_index = get_random_integer(0,1)
			if (field_number_array[random_player_index] > 0):
				field_array[i][j].set_color(Global.player_colors[random_player_index])
				field_number_array[random_player_index] -= 1
			else: 
				var opponent_player_index: int = get_opponent_index(random_player_index)
				field_array[i][j].set_color(Global.player_colors[opponent_player_index])
				field_number_array[opponent_player_index] -= 1

func get_opponent_index(random_player_index: int):
	return random_player_index == 0 if 1 else 0

func set_dices_of_fields(field_array):
	set_all_fields_to_have_one_dice(field_array)
	var player_dice_array = [NUMBER_OF_DICES, NUMBER_OF_DICES]
	
	while(!is_empty(player_dice_array)):
		#for i in range(0, ROW_COUNT):
			#for j in range(0, COLUMN_COUNT):
		var random_row = get_random_integer(0, ROW_COUNT - 1)
		var random_column = get_random_integer(0, COLUMN_COUNT - 1)
		
		var field = field_array[random_row][random_column]
		if field.dice_number < 8 && field.select_chance != 1 && field.select_chance != 2:	#give more equal distribution of dice values
			if field.color == Global.player_colors[FIRST_PLAYER_INDEX]:
				set_field_dice_if_valid(field, player_dice_array, FIRST_PLAYER_INDEX)
			
			elif field.color == Global.player_colors[SECOND_PLAYER_INDEX]:
				set_field_dice_if_valid(field, player_dice_array, SECOND_PLAYER_INDEX)
				
			field.select_chance += 1

func set_all_fields_to_have_one_dice(fields):
	for i in range(0, ROW_COUNT):
		for j in range(0, COLUMN_COUNT):
			set_field_dices(fields[i][j], 1)

func set_field_dice_if_valid(field, player_dice_array: Array, player_index):
	var random_dice_number = get_random_integer(1, MAX_FIELD_DICE_NUMBER - 1)	#because earlier we set all fields at least to value 1
	var updated_field_dice_number = field.dice_number + random_dice_number
	var updated_player_dice_number = player_dice_array[player_index] - random_dice_number
	
	if (updated_field_dice_number <= MAX_FIELD_DICE_NUMBER && updated_player_dice_number >= 0):
		set_field_dices(field, updated_field_dice_number)
		player_dice_array[player_index] = updated_player_dice_number
		
func is_empty(array: Array):
	for element in array:
		if element > 0:
			return false
	return true

func set_field_dices(field, settable_dice_number):
	field.set_text(String(settable_dice_number))
	field.dice_number = settable_dice_number
	
func get_random_integer(low_range, upper_range):
	var generator = RandomNumberGenerator.new()
	generator.randomize()
	return generator.randi_range(low_range, upper_range) 

func create_game_field():
	var scene = preload(HEXAGON_SCENE_PATH)
	var aggregated_offset = Vector2(0, 0)
	var field_array = []
	
	for i in range(0, ROW_COUNT):
		field_array.append([])
		field_array[i] = []
		var new_y = START_HEXA_COORD.y + aggregated_offset.y
		
		if i % 2 == 1:
			aggregated_offset.x = 0
		else:
			aggregated_offset.x = ROW_OFFSET
		
		for j in range(0, COLUMN_COUNT):
			field_array[i].append([])
			var new_x = START_HEXA_COORD.x + aggregated_offset.x
			
			var instance = create_instance(scene)
			field_array[i][j] = instance
			place_hexagon_tile(scene, instance, new_x, new_y)
			set_instance_coordinates(instance, i, j)
			aggregated_offset.x += OFFSET.x
			
		aggregated_offset.y += OFFSET.y
		
	return field_array

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
