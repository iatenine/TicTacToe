extends Node

var spaces:int = 8
var turn:String setget next_turn, get_turn

func _ready():
	turn = 'X'

func next_turn(_x):
	if(turn == 'O'):
		turn = 'X'
	else:
		turn = 'O'
	spaces -= 1

func get_turn() -> String:
	return turn
	pass
