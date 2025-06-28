class_name Kyoutia0

static var choice: int = -1
static var date_success: int = -1

static func date() -> bool:
	if date_success == -1:
		if randi_range(1, 100) <= 90:
			date_success = 1
		else:
			date_success = 0
	return date_success == 1

static func reset() -> void:
	choice = -1
	date_success = -1
