module rope

import buffer { InsertValue, RopeData }

// --- initialization ---
pub struct RopeBuffer {
mut:
	root     &RopeNode
	node_cap int = 2 // number of chacters in leaf before splitting
}

@[heap]
pub struct RopeNode {
pub mut:
	left   ?&RopeNode
	right  ?&RopeNode
	weight int // number of characters in left subtree
	data   ?RopeData
}

pub fn RopeBuffer.new(b RopeData) RopeBuffer {
	return RopeBuffer{
		root: &RopeNode{
			data: b
		}
	}
}

// --- buffer interface ---
// - [ ] insert(cursor int, s InsertValue)
// - [ ] delete(cursor int, n int)
// - [ ] to_string() string
// - [ ] len() int
// - [ ] line_count() int
// - [ ] line_at(i int)
// - [ ] char_at(i int) rune
// - [ ] slice(start int, end int) string
// - [ ] index_to_line_col(i int) (int, int)
// - [ ] line_col_to_index(line int, col int) int

pub fn (mut r RopeBuffer) insert(cursor int, s InsertValue) {
	r.root.insert(cursor, s, 0)
}

pub fn (mut r RopeBuffer) delete(cursor int, n int) {
	r.root.delete(cursor, n, 0)
}

pub fn (r RopeBuffer) to_string() string {
	mut res := ''
	for node in r.rope_iter() {
		if node.data != none {
			res += node.data.to_string()
		}
	}
	return res
}

pub fn len() int {
	return 0
}

pub fn line_count() int {
	return 0
}

pub fn line_at(i int) {
}

pub fn char_at(i int) rune {
	return rune(` `)
}

pub fn slice(start int, end int) string {
	return ''
}

pub fn index_to_line_col(i int) (int, int) {
	return 0, 0
}

pub fn line_col_to_index(line int, col int) int {
	return 0
}
