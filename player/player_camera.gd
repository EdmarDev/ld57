extends Camera2D


@export var _player: Player
@export var _bounds: Rect2
var _tween: Tween
var _tween_duration := 0.175

func _ready():
	_player.killable.killed.connect(set_process.bind(false))


func _process(_delta):
	_bounds.position = global_position - _bounds.size / 2
	var player_pos = _player.global_position
	var player_in_bounds = _bounds.has_point(player_pos)
	if !player_in_bounds:
		var x_diff := 0
		var y_diff := 0
		if player_pos.x > _bounds.end.x:
			x_diff = player_pos.x - _bounds.end.x
		elif player_pos.x < _bounds.position.x:
			x_diff = player_pos.x - _bounds.position.x
		if player_pos.y > _bounds.end.y:
			y_diff = player_pos.y - _bounds.end.y
		elif player_pos.y < _bounds.position.y:
			y_diff = player_pos.y - _bounds.position.y
		
		var target_pos = global_position + Vector2(x_diff, y_diff)
		if !!_tween:
			_tween.kill()
		_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		_tween.tween_property(self, "global_position", target_pos, _tween_duration)
		print("Target: %s, GP: %s" % [target_pos, global_position])
