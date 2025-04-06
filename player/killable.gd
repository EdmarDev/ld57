extends Node
class_name Killable

const COMPONENT_NAME = "Killable"
@export var _delete_parent := true

signal killed

func _ready():
	self.name = COMPONENT_NAME


func kill():
	killed.emit()
	if _delete_parent:
		get_parent().queue_free()