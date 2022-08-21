extends "res://addons/gut/test.gd"

var Battlefield = load("res://Battlefield.tscn")
var _battlefield = null

func before_each():
	#_battlefield = Battlefield.instance()
	#add_child(_battlefield)
	pass

func after_each():
	_battlefield.free()

var foo_params = ParameterFactory.named_parameters(
  ['row_count', 'column_count', 'expected_dice_number_of_a_player'], # names
  [[2, 2, 6], [3, 3, 12], [4, 4, 24], [5, 5, 36]]
)

# expected_dice_number_of_a_player = row_count * column_count / 2 (trunk because of dividing by odd numbers) * 3
func test_default_distribution_of_dices(params = use_parameters(foo_params)):
	Global.settings.row_count = params.row_count
	Global.settings.column_count = params.column_count
	
	_battlefield = Battlefield.instance()
	add_child(_battlefield)
	
	var first_group_name = str(_battlefield.PLAYER_PREFIX, 0)
	var second_group_name = str(_battlefield.PLAYER_PREFIX, 1)
	
	var first_player_fields = get_tree().get_nodes_in_group(first_group_name)
	var first_player_dices = count_all_dices(first_player_fields)
	var second_player_fields = get_tree().get_nodes_in_group(second_group_name)
	var second_player_dices = count_all_dices(second_player_fields)
	
	assert_eq(first_player_dices, params.expected_dice_number_of_a_player, "First player dice count is not expected!")
	assert_eq(second_player_dices, params.expected_dice_number_of_a_player, "Second player dice count is not expected! ")
	
func count_all_dices(fields) -> int:
	var sum = 0
	
	for field in fields:
		sum += field.dice_number
		
	return sum
