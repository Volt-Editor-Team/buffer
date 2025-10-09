module gap

import math
import buffer

// --- initialization ---
struct GapBuffer {
mut:
	data []u8
	gap  Gap
}

struct Gap {
mut:
	start int
	end   int
}

pub fn GapBuffer.new() GapBuffer {
	return GapBuffer{}
}

// --- buffer interface ---
// - [x] insert(cursor int, s InsertValue)
// - [x] delete(cursor int, n int)
// - [x] to_string() string
// - [x] len() int
// - [x] line_count() int
// - [ ] line_at(i int)
// - [x] char_at(i int) rune
// - [ ] slice(start int, end int) string
// - [ ] index_to_line_col(i int) (int, int)
// - [ ] line_col_to_index(line int, col int) int

pub fn (mut g GapBuffer) insert(index int, val buffer.InsertValue) {
	match val {
		rune {
			g.insert_rune(index, val)
		}
		u8 {
			g.insert_char(index, val)
		}
		[]rune {
			g.insert_runes(index, val)
		}
		string {
			g.insert_string(index, val)
		}
	}
}

// pub fn (mut g GapBuffer) delete(cursor int, count int) {
// 	g.shift_gap_to(cursor)
// 	g.gap.end = math.min(g.gap.end + count, g.data.len)
// }

pub fn (mut g GapBuffer) delete(cursor int, count int) {
	byte_index := g.char_to_byte_index(cursor)
	g.shift_gap_to(byte_index)
	if g.gap.end + count > g.data.len {
		g.gap.end = g.data.len
	} else {
		total_bytes := g.char_to_byte_index(cursor + count) - byte_index
		g.gap.end += total_bytes
	}
}

pub fn (g GapBuffer) to_string() string {
	// Only take the parts before and after the gap
	before := g.data[..g.gap.start]
	after := g.data[g.gap.end..]
	return before.bytestr() + after.bytestr()
}

pub fn (g GapBuffer) len() int {
	return g.to_string().runes().len
}

pub fn (g GapBuffer) line_count() int {
	mut lines := 0
	for byte in g.to_string() {
		if byte == 10 {
			lines++
		}
	}
	lines++

	return lines
}

pub fn (g GapBuffer) line_at(i int) []rune {
	return []
}

pub fn (g GapBuffer) char_at(index int) rune {
	return g.to_string().runes()[index]
}

pub fn (g GapBuffer) slice(start int, end int) string {
	return ''
}

pub fn (g GapBuffer) index_to_line_col(i int) (int, int) {
	return 0, 0
}

pub fn (g GapBuffer) line_col_to_index(line int, col int) int {
	return 0
}
