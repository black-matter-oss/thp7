class_name Quest
extends Object

signal quest_started(q: Quest)
signal quest_completed(q: Quest)

var id: String
var title: String
var description: String
var help: String
var is_complete: bool = false
