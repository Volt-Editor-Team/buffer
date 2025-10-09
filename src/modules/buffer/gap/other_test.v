module gap

fn test_line_count() {
	mut buf := GapBuffer.new()
	assert buf.line_count() == 1
	buf.insert(0, 'hello\nworld\n')
	assert buf.line_count() == 3
	buf.delete(11, 1)
	assert buf.to_string() == 'hello\nworld'
	assert buf.line_count() == 2
}

fn test_char_at() {
	mut buf := GapBuffer.new()
	buf.insert(0, 'hello world!')
	assert buf.char_at(5) == ` `
	buf.insert(5, ' 🌎')
	assert buf.to_string() == 'hello 🌎 world!'
	assert buf.char_at(6) == rune(`🌎`)
	assert buf.char_at(7) == ` `
}
