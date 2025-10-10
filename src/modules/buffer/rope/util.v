module rope

import buffer { InsertValue, get_insert_value_size }

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

fn (mut r RopeBuffer) check_split(node &RopeNode) {
	if node.left != none || node.right != none {
		return
	} else {
		if node.data != none {
			if node.data.len() > r.node_cap {
				// left, right := node.data.split()
				// node.left = left
				// node.right = right
				// node.weight = left.len()
				// node.data = none
			}
		} else {
			panic('Invalid Node')
		}
	}
}

fn (n &RopeNode) get_node(weight int) &RopeNode {
	if n.left == none && n.right == none {
		return n
	} else {
		if weight < n.weight {
			node := n.left or { panic('Invalid tree state: expected left node') }
			return node.get_node(weight)
		} else {
			node := n.right or { panic('Invalid tree state: expected right node') }
			return node.get_node(weight)
		}
	}
}

pub fn (n &RopeNode) total_len() int {
	if n.left == none && n.right == none {
		if n.data != none {
			return n.data.len()
		}
		return 0
	} else {
		mut total := 0
		if n.left != none {
			total += n.left.total_len()
		}
		if n.right != none {
			total += n.right.total_len()
		}
		return total
	}
}

fn (mut r RopeNode) insert(pos int, val InsertValue, offset int) {
	if r.left == none && r.right == none {
		if r.data != none {
			index := pos - offset
			r.data.insert(index, val)
		} else {
			panic('Invalid Node')
		}
	} else {
		if pos < r.weight {
			r.weight += get_insert_value_size(val)
			mut left := r.left or { panic('Invalid tree state: expected left node') }
			left.insert(pos, val, offset)
		} else {
			mut right := r.right or { panic('Invalid tree state: expected right node') }
			right.insert(pos, val, r.weight)
		}
	}
}

fn (mut r RopeNode) delete(pos int, num int, offset int) {
	if r.left == none && r.right == none {
		if r.data != none {
			index := pos - offset
			r.data.delete(index, num)
			r.weight = r.data.len()
		} else {
			panic('Invalid Node')
		}
	} else {
		if pos < r.weight {
			mut left := r.left or { panic('Invalid tree state: expected left node') }
			left.delete(pos, num, offset)
			r.weight = left.total_len()
		} else {
			mut right := r.right or { panic('Invalid tree state: expected right node') }
			right.delete(pos, num, r.weight)
		}
	}
}
