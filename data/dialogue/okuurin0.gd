class_name Okuurin0
extends Object

static var asked_food: bool = false
static var asked_drinks: bool = false
static var asked_entertainment: bool = false
static var asked_clothing: bool = false
static var told_food: bool = false
static var told_drinks: bool = false
static var told_entertainment: bool = false
static var told_clothing: bool = false
static var date_success_chance: int = 0
static var date_success: int = -1

static func date() -> bool:
	if date_success == -1:
		if randi_range(1, 100) <= date_success_chance:
			date_success = 1
		else:
			date_success = 0
	return date_success == 1
