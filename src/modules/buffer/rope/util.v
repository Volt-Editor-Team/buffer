module rope

fn (r &RopeNode) get_node(weight int) &RopeNode {
	if r.left == none && r.right == none {
		return r
	} else {
		if weight < r.weight {
			node := r.left or { panic('Invalid tree state: expected left node') }
			return node.get_node(weight)
		} else {
			node := r.right or { panic('Invalid tree state: expected left node') }
			return node.get_node(weight)
		}
	}
}
