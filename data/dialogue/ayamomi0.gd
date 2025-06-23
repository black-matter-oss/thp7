class_name Ayamomi0
extends Object

static var date_success_chance: int = 0
static var date_success: int = -1

static func date() -> bool:
	if date_success == -1:
		if randi_range(1, 100) <= date_success_chance:
			date_success = 1
		else:
			date_success = 0
	return date_success == 1
