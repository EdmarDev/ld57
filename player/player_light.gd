extends PointLight2D


@export var _player: Player
@export var _charged_color: Color
@export var _uncharged_color: Color
@export var _charged_tex_scale: float
@export var _uncharged_tex_scale: float
@export var _charged_energy: float
@export var _uncharged_energy: float
var _tween_duration = 0.1
var _tween: Tween

func _ready():
	_player.charged.connect(_on_player_charged)
	_player.charge_depleted.connect(_on_player_charge_depleted)
	_update_charge(_player.is_charged())


func _on_player_charged():
	_update_charge(true)


func _on_player_charge_depleted():
	_update_charge(false)


func _update_charge(charged: bool):
	if !!_tween:
		_tween.kill()
	_tween = create_tween().parallel()

	if charged:
		_tween.tween_property(self, "color", _charged_color, _tween_duration)
		_tween.tween_property(self, "energy", _charged_energy, _tween_duration)
		_tween.tween_property(self, "texture_scale", _charged_tex_scale, _tween_duration)
	else:
		_tween.tween_property(self, "color", _uncharged_color, _tween_duration)
		_tween.tween_property(self, "energy", _uncharged_energy, _tween_duration)
		_tween.tween_property(self, "texture_scale", _uncharged_tex_scale, _tween_duration)
