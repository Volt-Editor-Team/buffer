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

fn (r &RopeNode) get_node(weight int) &RopeNode {
	if r.left == none && r.right == none {
		return r
	} else {
		if weight < r.weight {
			node := r.left or { panic('Invalid tree state: expected left node') }
			return node.get_node(weight)
		} else {
			node := r.right or { panic('Invalid tree state: expected right node') }
			return node.get_node(weight)
		}
	}
}

fn (mut r RopeNode) insert(weight int, val InsertValue, offset int) &RopeNode {
	if r.left == none && r.right == none {
		index := weight - offset
		r.data.insert(index, val)
		return r
	} else {
		if weight < r.weight {
			r.weight += get_insert_value_size(val)
			mut node := r.left or { panic('Invalid tree state: expected left node') }
			return node.insert(weight, val, offset)
		} else {
			new_index_start := r.weight
			mut node := r.right or { panic('Invalid tree state: expected right node') }
			return node.insert(weight, val, new_index_start)
		}
	}
}
