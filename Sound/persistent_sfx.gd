extends Node


@onready var _menu_select := $MenuSelect as AudioStreamPlayer

func play_menu_select():
	_menu_select.play()
