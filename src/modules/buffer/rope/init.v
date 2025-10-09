module rope

import buffer

// --- initialization ---
pub struct RopeBuffer {
	root &RopeNode
}

@[heap]
pub struct RopeNode {
pub mut:
	left   ?&RopeNode
	right  ?&RopeNode
	weight int // number of characters in left subtree
	data   buffer.Buffer
}

pub fn RopeBuffer.new(b buffer.Buffer) RopeBuffer {
	return RopeBuffer{
		root: &RopeNode{
			data: b
		}
	}
}

struct RopeIter {
mut:
	stack []&RopeNode
	curr  ?&RopeNode
}

fn (mut it RopeIter) next() ?&RopeNode {
	mut node := it.curr or { return none }

	// Prepare next node
	if node.right != none {
		mut next := node.right
		for next.left != none {
			it.stack << next
			next = next.left?
		}
		it.curr = next
	} else if it.stack.len > 0 {
		it.curr = it.stack.pop()
	} else {
		it.curr = none
	}

	return node
}

fn (r RopeBuffer) rope_iter() &RopeIter {
	return &RopeIter{
		curr: r.root
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

pub fn (mut r RopeBuffer) insert(cursor int, s buffer.InsertValue) {
	mut node := r.root.get_node(cursor)
	node.data.insert(cursor, s)
}

pub fn delete(cursor int, n int) {
}

pub fn (r RopeBuffer) to_string() string {
	mut res := ''
	for node in r.rope_iter() {
		res += node.data.to_string()
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
