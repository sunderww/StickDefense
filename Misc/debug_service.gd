extends Node

# Silly: puts debug on screen
enum LogLevel { SILLY = 1, DEBUG, INFO, WARNING, ERROR }
var level = LogLevel.INFO

func _level_as_str(lvl):
	match lvl:
		LogLevel.SILLY:
			return "SILLY"
		LogLevel.DEBUG:
			return "DEBUG"
		LogLevel.INFO:
			return "INFO"
		LogLevel.WARNING:
			return "WARNING"
		LogLevel.ERROR:
			return "ERROR"

func _print_if_level(msg, expected_level):
	var s = "%s: %s" % [_level_as_str(expected_level), msg]
	if level <= expected_level:
		print(s)

func silly(msg):
	_print_if_level(msg, LogLevel.SILLY)

func debug(msg):
	_print_if_level(msg, LogLevel.DEBUG)

func info(msg):
	_print_if_level(msg, LogLevel.INFO)

func warning(msg):
	_print_if_level(msg, LogLevel.WARNING)

func error(msg):
	_print_if_level(msg, LogLevel.ERROR)
