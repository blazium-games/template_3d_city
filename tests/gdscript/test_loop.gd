extends AutoworkTest

const Rules = preload("res://scripts/rules.gd")

func test_seed_repeats() -> void:
	var rules = Rules.new()
	assert_eq(rules.block_widths(7), rules.block_widths(7), "same seed")
	assert_ne(rules.block_widths(7), rules.block_widths(8), "other seed")

func test_scale_reject() -> void:
	var rules = Rules.new()
	assert_true(rules.scale_accepted(1.0), "unit scale")
	assert_false(rules.scale_accepted(0.5), "bad scale")

func test_cross_gate() -> void:
	var rules = Rules.new()
	assert_false(rules.may_cross(), "bar shut")
	rules.open_bar()
	assert_true(rules.may_cross(), "bar open")
	assert_true(load("res://scenes/cross.tscn") != null, "cross loads")

func test_curb_open() -> void:
	var rules = Rules.new()
	assert_false(rules.curb_open("closed"), "phase closed")
	assert_false(rules.may_cross(), "crossing waits")
	rules.open_bar()
	assert_true(rules.curb_open(rules.phase), "phase open")
