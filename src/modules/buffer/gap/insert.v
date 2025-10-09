module gap

fn (mut g GapBuffer) insert_rune(cursor int, ch rune) {
	check_gap_size(mut g, ch.length_in_bytes())
	byte_index := g.char_to_byte_index(cursor)
	g.shift_gap_to(byte_index)
	for i, byte in ch.bytes() {
		g.data[g.gap.start + i] = byte
	}
	g.gap.start += ch.length_in_bytes()
}

fn (mut g GapBuffer) insert_char(cursor int, ch u8) {
	check_gap_size(mut g, 1)
	byte_index := g.char_to_byte_index(cursor)
	g.shift_gap_to(byte_index)
	g.data[g.gap.start] = ch
	g.gap.start++
}

fn (mut g GapBuffer) insert_bytes(cursor int, bytes []u8) {
	check_gap_size(mut g, bytes.len)
	byte_index := g.char_to_byte_index(cursor)
	g.shift_gap_to(byte_index)
	for i, b in bytes {
		g.data[g.gap.start + i] = b
	}
	g.gap.start += bytes.len
}

fn (mut g GapBuffer) insert_runes(cursor int, slice []rune) {
	bytes := slice.string().bytes()
	g.insert_bytes(cursor, bytes)
}

fn (mut g GapBuffer) insert_string(cursor int, str string) {
	bytes := str.bytes()
	g.insert_bytes(cursor, bytes)
}
