extends CharacterBody2D
class_name Enemy

var facing_direction := 1

func _physics_process(_delta: float):
	move_and_slide()


func face_direction(dir: int):
	if dir < 0 and facing_direction == 1:
		self.transform.x *= -1
		facing_direction = -1
	elif dir > 0 and facing_direction == -1:
		self.transform.x *= -1
		facing_direction = 1
