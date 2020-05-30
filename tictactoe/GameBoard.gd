extends Node2D

#Begin enumeration at 1 so values can be added when checking
enum diag_victory {UPPER_LEFT=1, LOWER_LEFT, BOTH}

var square_scene = preload("res://square.tscn")
var squares = []
var board = [["", "", ""], 
["", "", ""], 
["", "", ""]]
onready var popup = $PopupDialog

func _ready():
	popup.connect("confirmed", self, "_on_popup_confirmed")
	squares.resize(9)
	
	for x in squares.size():
		var coords = Vector2(x%3, x/3)
		squares[x] = square_scene.instance()
		$GridContainer.add_child(squares[x])
		squares[x].set_pos(coords)
		squares[x].connect("value_set", self, "_on_value_set", [squares[x].board_position])

func _end_game(msg:String):
	for x in squares:
		x.disabled = true
	popup.dialog_text = msg
	popup.show()

func _on_value_set(board_pos):
	board[board_pos.y][board_pos.x] = Game.get_turn()
	var win = _check_victory()
	if(win == PoolIntArray([-1, -1, -1]) and Game.spaces == 0):
		_end_game("CAT GAME!")
	for x in win:
		if(x != -1):
			_end_game(Game.get_turn() + " WINS!")
	Game.next_turn("")

func _on_popup_confirmed():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()

# return [-1, -1, -1] if no win detected
# x and y values reflect winning row/col index
func _check_victory() -> PoolIntArray:
	var x = check_rows()
	var y = check_cols()
	var z = check_diags()
	return PoolIntArray([x, y, z])

func check_cols() -> int:
	for x in board.size():
		var arr = [board[0][x], board[1][x], board[2][x]]
		if(arr.has("")):
			continue
		elif (arr[0] == arr[1] and arr[1] == arr[2]):
			return x
	return -1

func check_rows() -> int:
	for x in board.size():
		var arr:Array = board[x]
		if arr.has(""):
			continue
		if(arr[0] == arr[1] and arr[1] == arr[2]):
			return x
	return -1

func check_diags() -> int:
	var ret = -1
	var center_val = board[1][1]
	if center_val == "":
		return ret
	if board[0][0] == board [2][2] and board[0][0] == center_val:
		ret += diag_victory.UPPER_LEFT
	if board[0][2] == board[2][0] and board[0][2] == center_val:
		ret += diag_victory.LOWER_LEFT
	return ret
