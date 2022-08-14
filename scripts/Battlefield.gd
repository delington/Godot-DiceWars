extends Node2D

const HEXAGON_SCENE_PATH = "res://HexaSprite.tscn"
const WELCOME_SCENE_PATH = "res://WelcomeScreen.tscn"
var ROW_COUNT = Global.settings.row_count
var COLUMN_COUNT = Global.settings.column_count
const ROW_OFFSET = 44
const OFFSET = Vector2(88, 73)
const START_HEXA_COORD = Vector2(50, 50)
var NUMBER_OF_FIELDS = COLUMN_COUNT * ROW_COUNT
const NUMBER_OF_PLAYERS = 2
var ONE_PLAYER_ALL_FIELDS = NUMBER_OF_FIELDS / 2
var NUMBER_OF_DICES = ONE_PLAYER_ALL_FIELDS * 2 # it would be 3 times but we set all fields to have at least 1 dice on it
const MAX_FIELD_DICE_NUMBER = 8
const MAX_VALUE_OF_A_DICE = 6
const FIRST_PLAYER_INDEX = 0
const SECOND_PLAYER_INDEX = 1
const TURN_LABEL_POSTFIX = "'s turn"
const WINNER_LABEL_POSTFIX = " wins!"
const FIRST_LINE_OFFSET = true
const UPDATED_FIELD_DICE_NUMBER = "updated_field_dice_number"
const UPDATED_PLAYER_DICE_NUMBER = "updated_player_dice_number"
const PLAYER_PREFIX = "player_"

onready var start_label = $"%StartLabel" as Label
onready var end_turn_button = $"%EndTurnButton" as Button
onready var attacker_scoring_label = $"%AttackerScoring" as Label
onready var defender_scoring_label = $"%DefenderScoring" as Label
onready var attacker_label = $"%AttackerLabel" as Label
onready var defender_label = $"%DefenderLabel" as Label
onready var attacker_animation = $"%AttackerAnimation" as AnimationPlayer
onready var defender_animation = $"%DefenderAnimation" as AnimationPlayer
onready var turn_animation = $"%TurnAnimation" as AnimationPlayer
onready var end_game_label_winner_animation = $"%WinnerAnimation" as AnimationPlayer
onready var end_game_label = $"%EndGameLabel" as Label
onready var winner_label = $"%WinnerLabel" as Label

var attack_from
var is_set_attack_from = false   # for player can only select 1 field to attack from
var field_array: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.ref["Battlefield"] = self

	set_start_label()
	
	field_array = create_game_field()
	set_color_of_fields(field_array)
	set_dices_of_fields(field_array)

	end_game_label.hide()
	winner_label.hide()

func set_start_label():
	var selected_player_index: int = Global.current_player_index
	
	if selected_player_index >= 0:
		start_label.set_text_and_color(selected_player_index)
	else:
		print("ERROR: player index is out of bounds!")

func set_color_of_fields(field_array):
	# Dice counts to distribute by players
	var field_number_array = [ONE_PLAYER_ALL_FIELDS, ONE_PLAYER_ALL_FIELDS]
	
	for i in range(0, ROW_COUNT):
		for j in range(0, COLUMN_COUNT):
			var random_player_index = get_random_integer(0,1)
			if (field_number_array[random_player_index] > 0):
				handle_attach_field_to_player(field_array[i][j], random_player_index, field_number_array)
			else: 
				var opponent_player_index: int = get_opponent_index(random_player_index)
				handle_attach_field_to_player(field_array[i][j], opponent_player_index, field_number_array)
				
func handle_attach_field_to_player(field, player_index, field_number_array):
	field.set_group(player_index)
	field.set_color(Global.get_player_color_value_by_index(player_index))
	field_number_array[player_index] -= 1

func get_opponent_index(random_player_index: int) -> int:
	return random_player_index == 0 if 1 else 0

func set_dices_of_fields(field_array):
	set_all_fields_to_have_one_dice(field_array)
	var player_dice_array = [NUMBER_OF_DICES, NUMBER_OF_DICES]
	
	while(!is_empty(player_dice_array)):
		var random_row = get_random_integer(0, ROW_COUNT - 1) #inclusive ranges
		var random_column = get_random_integer(0, COLUMN_COUNT - 1)
		
		var field = field_array[random_row][random_column]
		if field.dice_number < MAX_FIELD_DICE_NUMBER:
			field.select_chance += 1
			
			if (field.select_chance != 1 && field.select_chance != 2): #give more equal distribution of dice values

				if field.color == Global.get_player_color_value_by_index(FIRST_PLAYER_INDEX) :
					set_field_dice_if_valid(field, player_dice_array, FIRST_PLAYER_INDEX)
				
				elif field.color == Global.get_player_color_value_by_index(SECOND_PLAYER_INDEX) :
					set_field_dice_if_valid(field, player_dice_array, SECOND_PLAYER_INDEX)
				
			
func distribute_additional_player_dices(field_array):
	var group_name = str(PLAYER_PREFIX, Global.current_player_index)
	var current_player_fields = get_tree().get_nodes_in_group(group_name)
	assert (current_player_fields != null, "Could not find current player field in the group: %s" % group_name)
	
	var current_player_field_count = current_player_fields.size()
	
	var player_dice_count = current_player_field_count / 2
	var sum_of_max_dice_fields = 0
	
	while(player_dice_count > 0):
		var max_of_player_dices = current_player_field_count * MAX_FIELD_DICE_NUMBER
		
		if (get_sum_of_player_dices(group_name) >= max_of_player_dices):	# check if all fields are full
			return
		
		for i in range(0, ROW_COUNT): #exclusive upper range
			for j in range(0, COLUMN_COUNT):
				var current_field = field_array[i][j]
				var current_field_dice_number = current_field.dice_number
				
				if (current_field.color == Global.get_current_player().value && current_field_dice_number < MAX_FIELD_DICE_NUMBER): #can put dices to the field
					var dice_map = get_player_and_field_updated_dice_parameters_without_redundant_random_values(current_field_dice_number, player_dice_count) #add that number of dices which still can be placed
					
					if (dice_map[UPDATED_FIELD_DICE_NUMBER] <= MAX_FIELD_DICE_NUMBER && dice_map[UPDATED_PLAYER_DICE_NUMBER] >= 0):
						current_field.set_dice_number(dice_map[UPDATED_FIELD_DICE_NUMBER])
						player_dice_count = dice_map[UPDATED_PLAYER_DICE_NUMBER]

func get_sum_of_player_dices(group_name) -> int:
	var player_fields = get_tree().get_nodes_in_group(group_name)
	var sum_of_dices = 0
	
	for field in player_fields:
		sum_of_dices += field.dice_number
	
	return sum_of_dices

func set_all_fields_to_have_one_dice(fields):
	for i in range(0, ROW_COUNT):
		for j in range(0, COLUMN_COUNT):
			fields[i][j].set_dice_number(1)

func get_player_and_field_updated_dice_parameters_without_redundant_random_values(field_dice_number: int, player_dice_count: int):
	return get_player_and_field_updated_dice_parameters(field_dice_number, player_dice_count, field_dice_number)

func get_player_and_field_updated_dice_parameters(field_dice_number: int, player_dice_count: int, difference_of_max_random_value: int):
	var random_dice_number = get_random_integer(1, MAX_FIELD_DICE_NUMBER - difference_of_max_random_value)
	var updated_field_dice_number = field_dice_number + random_dice_number
	var updated_player_dice_number = player_dice_count - random_dice_number
	
	return {
		UPDATED_FIELD_DICE_NUMBER: updated_field_dice_number,
		UPDATED_PLAYER_DICE_NUMBER: updated_player_dice_number
	}

func set_field_dice_if_valid(field, player_dice_array: Array, player_index):
	var updated_data_map = get_player_and_field_updated_dice_parameters(field.dice_number, player_dice_array[player_index], 1) #last param is 1 because earlier we set all fields at least to value 1
	var updated_field_dice_number = updated_data_map[UPDATED_FIELD_DICE_NUMBER]
	var updated_player_dice_number = updated_data_map[UPDATED_PLAYER_DICE_NUMBER]
	
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
	
	var defender_player_index: int = get_opponent_index(attacker_player_index) as int
	defender_label.modulate = Global.player_colors_dict[defender_player_index].value
	
	# When the attacker wins
	if (attacker_score > defender_score):
		attacker_animation.play("turn_attacker")
		attach_defender_field_to_attacker(attacker, defender)
		attacker.set_dice_number(1)    #move dices to defender's field

		defender.remove_group(defender_player_index)
		defender.set_group(attacker_player_index)

		if(is_end_of_game()):
			handle_game_end()
		
		return attacker_player_index
	
	# Else the defender wins
	defender_animation.play("turn_defender")
	attacker.set_dice_number(1)   #attacker lose dices except one

	return get_opponent_index(attacker_player_index)

func handle_game_end():
	end_game_label.show()
	end_game_label_winner_animation.play("default")

	var current_player = Global.get_current_player()
	winner_label.text = str(current_player.text, WINNER_LABEL_POSTFIX)
	winner_label.add_color_override("font_color", current_player.value)
	winner_label.show()
	
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

func is_end_of_game() -> bool:
	var group_name = str(PLAYER_PREFIX, Global.current_player_index)
	var current_player_fields = get_tree().get_nodes_in_group(group_name)

	if (current_player_fields.size() == NUMBER_OF_FIELDS):
		return true
		
	return false	#current player wins the game
		
func _on_EndTurnButton_pressed():
	distribute_additional_player_dices(field_array)
	
	var opponent_index: int = get_opponent_index(Global.current_player_index)
	Global.current_player_index = opponent_index
	
	start_label.set_text_and_color(opponent_index)
	
	manage_end_button_animation(turn_animation)

func manage_end_button_animation(animation):
	turn_animation.stop()
	turn_animation.play("default")
