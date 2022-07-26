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
const MAX_VALUE_OF_A_DICE = 6
const FIRST_PLAYER_INDEX = 0
const SECOND_PLAYER_INDEX = 1
const TURN_LABEL = "'s turn"
const FIRST_LINE_OFFSET = true

onready var start_label = $"StartLabel"
onready var end_turn_button = $"EndTurnButton"
onready var end_button_animation_sprite = $"EndTurnButton/EndTurnButtonAnimationSprite"
onready var attacker_scoring_label = $"AttackerScoring"
onready var defender_scoring_label = $"DefenderScoring"
onready var attacker_label = $"AttackerScoring/AttackerLabel"
onready var defender_label = $"DefenderScoring/DefenderLabel"
onready var attacker_animation = $"AttackerScoring/AttackerSprite/WinnerAnimation"
onready var defender_animation = $"DefenderScoring/DefenderSprite/WinnerAnimation"

var attack_from
var is_set_attack_from = false   # for player can only select 1 field to attack from
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
	# Dice counts to distribute by players
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
		if field.dice_number < MAX_FIELD_DICE_NUMBER && field.select_chance != 1 && field.select_chance != 2:	#give more equal distribution of dice values
			if field.color == Global.get_player_color_value_by_index(FIRST_PLAYER_INDEX) :
				set_field_dice_if_valid(field, player_dice_array, FIRST_PLAYER_INDEX)
			
			elif field.color == Global.get_player_color_value_by_index(SECOND_PLAYER_INDEX) :
				set_field_dice_if_valid(field, player_dice_array, SECOND_PLAYER_INDEX)
				
			field.select_chance += 1

func set_all_fields_to_have_one_dice(fields):
	for i in range(0, ROW_COUNT):
		for j in range(0, COLUMN_COUNT):
			fields[i][j].set_dice_number(1)

func set_field_dice_if_valid(field, player_dice_array: Array, player_index):
	var random_dice_number = get_random_integer(1, MAX_FIELD_DICE_NUMBER - 1)	#because earlier we set all fields at least to value 1
	var updated_field_dice_number = field.dice_number + random_dice_number
	var updated_player_dice_number = player_dice_array[player_index] - random_dice_number
	
	# If we can deal more dice(s) to the field we do it
	if (updated_field_dice_number <= MAX_FIELD_DICE_NUMBER && updated_player_dice_number >= 0):
		field.set_dice_number(updated_field_dice_number)
		player_dice_array[player_index] = updated_player_dice_number
		
func is_empty(array: Array):
	for element in array:
		if element > 0:
			return false
	return true
	
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
		
		if is_first_line_offset(i):
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

func is_first_line_offset(i):
	if FIRST_LINE_OFFSET:
		return i % 2 == 1
	return i % 2 == 0

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
	
	# When attacker select the field to attack from
	if (field.color == current_player_color && !is_set_attack_from && field.dice_number > 1):
		field.set_selected()
		attack_from = get_field_from_array(field.coordinate)
		is_set_attack_from = true
		
	# When attacker unselect the already selected field
	elif (field.color == current_player_color && is_set_attack_from && attack_from != null \
	&& field.coordinate == attack_from.coordinate):
		field.set_unselected()
		is_set_attack_from = false
		
	# When attacker select the field to attack
	elif (field.color == opponent_player_color && is_set_attack_from \
	&& is_neighbour(attack_from.coordinate, field.coordinate)):
		var winner_player_index = get_winner(attack_from, field, Global.current_player_index)
		
		is_set_attack_from = false
		attack_from.set_unselected()
		
func get_winner(attacker, defender, attacker_player_index: int) -> int:
	var attacker_score = get_dice_score(attacker.dice_number)
	attacker_scoring_label.text = attacker_score as String
	attacker_label.modulate = Global.player_colors_dict[attacker_player_index].value
	
	var defender_score = get_dice_score(defender.dice_number)
	defender_scoring_label.text = defender_score as String
	defender_label.modulate = Global.player_colors_dict[get_opponent_index(attacker_player_index) as int].value
	
	# When the attacker wins
	if (attacker_score > defender_score):
		attacker_animation.play("turn_attacker")
		attach_defender_field_to_attacker(attacker, defender)
		attacker.set_dice_number(1)    #move dices to defender's field
		
		return attacker_player_index
	
	# Else the defender wins
	defender_animation.play("turn_defender")
	attacker.set_dice_number(1)   #attacker lose dices except one
	return get_opponent_index(attacker_player_index)
	
func attach_defender_field_to_attacker(attacker_field, defender_field):
	var new_dice_number = attacker_field.dice_number - 1
	defender_field.set_dice_number(new_dice_number)
	defender_field.set_color(attacker_field.color)
	
func get_dice_score(dice_number) -> int:
	return get_random_integer(dice_number, dice_number * MAX_VALUE_OF_A_DICE)

func get_field_from_array(coordinate: Vector2):
	return field_array[coordinate.x][coordinate.y]

func is_neighbour(attacker_coord: Vector2, defender_coord: Vector2):
	var delta = defender_coord - attacker_coord
	if (FIRST_LINE_OFFSET):
		if (attacker_coord.x as int % 2 == 0):
			for valid_delta in Global.DELTA_LIST_OF_NEIGHBOUR_FIELD.even_rows:
				if (delta == valid_delta):
					return true
		elif (attacker_coord.x as int % 2 == 1):
			for valid_delta in Global.DELTA_LIST_OF_NEIGHBOUR_FIELD.odd_rows:
				if (delta == valid_delta):
					return true
	return false
		
func _on_EndTurnButton_pressed():
	var opponent_index: int = get_opponent_index(Global.current_player_index)
	Global.current_player_index = opponent_index
	
	var opponent_color: String = Global.player_colors_dict[opponent_index].text
	start_label.text = str(opponent_color, TURN_LABEL)
	
	manage_end_button_animation(end_button_animation_sprite)

func manage_end_button_animation(animation_sprite):
	animation_sprite.frame = 0
	animation_sprite.play()
