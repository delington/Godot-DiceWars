extends Node2D

const HEXAGON_SCENE_PATH = "res://HexaSprite.tscn"
const WELCOME_SCENE_PATH = "res://WelcomeScreen.tscn"
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
const TURN_LABEL = "'s turn"

onready var start_label = $"StartLabel"
onready var end_turn_button = $"EndTurnButton"
onready var end_button_animation_sprite = $"EndTurnButton/EndTurnButtonAnimationSprite"
onready var attacker_scoring_label = $"AttackerScoring"
onready var defender_scoring_label = $"DefenderScoring"
onready var attacker_label = $"AttackerScoring/AttackerLabel"
onready var defender_label = $"DefenderScoring/DefenderLabel"

var attack_from
var attack_to
var is_set_attack_from = false
var field_array: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.ref["Battlefield"] = self
	
	field_array = create_game_field()
	set_color_of_fields(field_array)
	set_dices_of_fields(field_array)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(parameters)
	pass

func set_start_label():
	var selected_player_index: int = Global.current_player_index
	
	if selected_player_index >= 0:
		var selected_player_color = Global.get_player_color_name_by_index(selected_player_index)
		start_label.text = str(selected_player_color, TURN_LABEL)
	else:
		print("ERROR: player index is out of bounds!")

func set_color_of_fields(field_array):
	var field_number_array = [ONE_PLAYER_ALL_FIELDS, ONE_PLAYER_ALL_FIELDS]
	
	for i in range(0, ROW_COUNT):
		for j in range(0, COLUMN_COUNT):
			var random_player_index = get_random_integer(0,1)
			if (field_number_array[random_player_index] > 0):
				field_array[i][j].set_color(Global.get_player_color_value_by_index(random_player_index))
				field_number_array[random_player_index] -= 1
			else: 
				var opponent_player_index: int = get_opponent_index(random_player_index)
				field_array[i][j].set_color(Global.get_player_color_value_by_index(opponent_player_index))
				field_number_array[opponent_player_index] -= 1

func get_opponent_index(random_player_index: int) -> int:
	return random_player_index == 0 if 1 else 0

func set_dices_of_fields(field_array):
	set_all_fields_to_have_one_dice(field_array)
	var player_dice_array = [NUMBER_OF_DICES, NUMBER_OF_DICES]
	
	while(!is_empty(player_dice_array)):
		var random_row = get_random_integer(0, ROW_COUNT - 1)
		var random_column = get_random_integer(0, COLUMN_COUNT - 1)
		
		var field = field_array[random_row][random_column]
		if field.dice_number < 8 && field.select_chance != 1 && field.select_chance != 2:	#give more equal distribution of dice values
			if field.color == Global.get_player_color_value_by_index(FIRST_PLAYER_INDEX) :
				set_field_dice_if_valid(field, player_dice_array, FIRST_PLAYER_INDEX)
			
			elif field.color == Global.get_player_color_value_by_index(SECOND_PLAYER_INDEX) :
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

func create_game_field() -> Array:
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
	
func handle_battle(field):
	var current_player_color: Color = Global.player_colors_dict[Global.current_player_index].value
	var opponent_index: int = get_opponent_index(Global.current_player_index)
	var opponent_player_color: Color = Global.player_colors_dict[opponent_index].value
	
	if (field.color == current_player_color && !is_set_attack_from && field.dice_number > 1):
		handle_attributes_change_of_field(field)
		attack_from = get_field_from_array(field.coordinate)
		is_set_attack_from = true
		
	elif (field.color == opponent_player_color):
		get_winner(attack_from, field, Global.current_player_index)
		is_set_attack_from = false
		
func get_winner(attacker, defender, attacker_player_index: int) -> int:
	var attacker_score = get_dice_score(attacker.dice_number)
	attacker_scoring_label.text = attacker_score as String
	attacker_label.modulate = Global.player_colors_dict[attacker_player_index].value
	
	var defender_score = get_dice_score(defender.dice_number)
	defender_scoring_label.text = defender_score as String
	defender_label.modulate = Global.player_colors_dict[get_opponent_index(attacker_player_index) as int].value
	
	if (attacker_score > defender_score):
		return attacker_player_index
	
	return get_opponent_index(attacker_player_index)
	
func get_dice_score(dice_number) -> int:
	return get_random_integer(dice_number, dice_number * 8)

func get_field_from_array(coordinate: Vector2):
	return field_array[coordinate.x][coordinate.y]

func handle_attributes_change_of_field(field):
	if field.selected:
		field.set_unselected()
	else: 
		field.set_selected()


func _on_EndTurnButton_pressed():
	var opponent_index: int = get_opponent_index(Global.current_player_index)
	Global.current_player_index = opponent_index
	
	var opponent_color: String = Global.player_colors_dict[opponent_index].text
	start_label.text = str(opponent_color, TURN_LABEL)
	
	manage_end_button_animation(end_button_animation_sprite)

func manage_end_button_animation(animation_sprite):
	animation_sprite.frame = 0
	animation_sprite.play()
