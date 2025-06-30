class_name Rumicine0
extends Object

static var success: int = 40
static var successful := -1
static var antipoison := false

static func test() -> bool:
	if successful == -1:
		if randi_range(1, 100) <= success:
			successful = 1
		else:
			successful = 0
	return successful == 1

static func reset() -> void:
	success = 50
	successful = -1
	antipoison = false
