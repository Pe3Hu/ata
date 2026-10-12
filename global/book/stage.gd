class_name Stage
extends RefCounted

## One step of a Book.
## The trigger calls fire() when the step is ready to pause the game.
## target is a Focus key, a node, or a Callable that returns one.


signal triggered
@warning_ignore("unused_signal")
signal finished

var text := ""
var target = null
var trigger: Callable

var _fired := false


static func now(text_: String, target_ = null) -> Stage:
	var stage := Stage.new()
	stage.text = text_
	stage.target = target_
	stage.trigger = func(s: Stage):
		s.fire()
	return stage


static func after(seconds: float, text_: String, target_ = null) -> Stage:
	var stage := Stage.new()
	stage.text = text_
	stage.target = target_
	stage.trigger = func(s: Stage):
		Book.get_tree().create_timer(seconds, true).timeout.connect(s.fire)
	return stage


static func on_signal(sig: Signal, text_: String, target_ = null) -> Stage:
	var stage := Stage.new()
	stage.text = text_
	stage.target = target_
	stage.trigger = func(s: Stage):
		if not sig.is_connected(s.fire):
			sig.connect(s.fire, CONNECT_ONE_SHOT)
	return stage


static func when_met(condition: Callable, text_: String, target_ = null) -> Stage:
	var stage := Stage.new()
	stage.text = text_
	stage.target = target_
	stage.trigger = func(s: Stage):
		s._poll(condition)
	return stage


func arm() -> void:
	_fired = false
	if trigger.is_valid():
		trigger.call(self)


func fire(_a = null, _b = null, _c = null) -> void:
	if _fired:
		return
	_fired = true
	triggered.emit()


func resolve_target():
	if target is Callable and (target as Callable).is_valid():
		return (target as Callable).call()
	return target


func _poll(condition: Callable) -> void:
	if _fired:
		return
	if condition.is_valid() and condition.call():
		fire()
		return
	Book.get_tree().create_timer(0.1, true).timeout.connect(_poll.bind(condition))
