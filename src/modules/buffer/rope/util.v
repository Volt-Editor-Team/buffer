module rope

import buffer { InsertValue, get_insert_value_size }

// struct RopeIter {
// mut:
// 	current    ?&RopeNode
// 	right_most ?&RopeNode
// }

// fn (mut it RopeIter) has_next() bool {
// 	return it.current != none
// }

// fn (mut it RopeIter) next() ?&RopeNode {
// 	if it.current == none {
// 		return none
// 	}
// 	mut curr := it.current or { return none }
// 	if curr.left == none {
// 		it.current = curr.right
// 		return curr
// 	}

// 	it.right_most = curr.left or { return none }

// 	for {
// 		rm := it.right_most or { return none }
// 		right_node := rm.right or { return none }
// 		current_node := it.current or { return none }
// 		if rm.right == none || right_node == current_node {
// 			break
// 		}

// 		it.right_most = rm.right
// 	}

// 	mut rm := it.right_most or { return none }

// 	if rm.right == none {
// 		unsafe {
// 			rm.right = it.current
// 		}
// 		it.current = curr.left
// 		return it.next() or { return none }
// 	} else {
// 		unsafe {
// 			rm.right = none
// 		}
// 		it.current = curr.right
// 		return curr
// 	}
// }

// fn (r &RopeBuffer) rope_iter() RopeIter {
// 	return RopeIter{
// 		current: r.root
// 	}
// }

fn in_order(node &RopeNode, mut res []&RopeNode) {
	if node.left != unsafe { nil } {
		in_order(node.left, mut res)
	}

	if node.data != none {
		res << node
	}

	if node.right != unsafe { nil } {
		in_order(node.right, mut res)
	}
}

fn (mut r RopeBuffer) check_split(mut node RopeNode) {
	if node.left != unsafe { nil } || node.right != unsafe { nil } {
		return
	} else {
		if node.data != none {
			// split current node and remove data -- this node is no longer a leaf
			if node.data.len() > r.node_cap {
				left, right := node.data.split()
				node.left = &RopeNode{
					data: left
				}
				node.right = &RopeNode{
					data: right
				}
				node.weight = left.len()
				node.data = none
			}

			// recursive check left to split
			if node.left != unsafe { nil } {
				if data := node.left.data {
					if data.len() > r.node_cap {
						r.check_split(mut node.left)
					}
				}
			}

			// recursive check right to split
			if node.right != unsafe { nil } {
				if data := node.right.data {
					if data.len() > r.node_cap {
						r.check_split(mut node.right)
					}
				}
			}
		} else {
			panic('Invalid Node')
		}
	}
}

fn (n &RopeNode) get_node(weight int) &RopeNode {
	if n.left == unsafe { nil } && n.right == unsafe { nil } {
		return n
	} else {
		if weight < n.weight {
			if n.left == unsafe { nil } {
				panic('Invalid tree state: expected left node')
			}
			return n.left.get_node(weight)
		} else {
			if n.right == unsafe { nil } {
				panic('Invalid tree state: expected right node')
			}
			return n.right.get_node(weight)
		}
	}
}

pub fn (n &RopeNode) total_len() int {
	if n.left == unsafe { nil } && n.right == unsafe { nil } {
		if n.data != none {
			return n.data.len()
		}
		return 0
	} else {
		mut total := 0
		if n.left != unsafe { nil } {
			total += n.left.total_len()
		}
		if n.right != unsafe { nil } {
			total += n.right.total_len()
		}
		return total
	}
}

fn (mut r RopeNode) insert(pos int, val InsertValue, offset int) &RopeNode {
	if r.left == unsafe { nil } && r.right == unsafe { nil } {
		if r.data == none {
			panic('Invalid Node')
		} else {
			index := pos - offset
			r.data.insert(index, val)
			return r
		}
	} else {
		if pos < r.weight {
			r.weight += get_insert_value_size(val)
			if r.left == unsafe { nil } {
				panic('Invalid tree state: expected left node')
			}
			return r.left.insert(pos, val, offset)
		} else {
			if r.right == unsafe { nil } {
				panic('Invalid tree state: expected right node')
			}
			return r.right.insert(pos, val, r.weight)
		}
	}
}

fn (mut r RopeNode) delete(pos int, num int, offset int) {
	if r.left == unsafe { nil } && r.right == unsafe { nil } {
		if r.data == none {
			panic('Invalid Node')
		} else {
			index := pos - offset
			r.data.delete(index, num)
			r.weight = r.data.len()
		}
	} else {
		if pos < r.weight {
			if r.left == unsafe { nil } {
				panic('Invalid tree state: expected left node')
			}
			r.left.delete(pos, num, offset)
			r.weight = r.left.total_len()
		} else {
			if r.right == unsafe { nil } {
				panic('Invalid tree state: expected right node')
			}
			r.right.delete(pos, num, r.weight)
		}
	}
}
