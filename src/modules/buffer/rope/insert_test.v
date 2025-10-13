module rope

import gap

fn test_insert() {
	mut buf := RopeBuffer.new(gap.GapBuffer.new())
	buf.insert(0, 'hello world')
	assert buf.to_string() == 'hello world'
	assert buf.len() == 11
}

fn test_insert_causes_split() {
	mut buf := RopeBuffer{
		root:     &RopeNode{
			data: gap.GapBuffer.new()
		}
		node_cap: 2
	}
	buf.insert(0, 'hello world')
	assert buf.to_string() == 'hello world'
	assert buf.len() == 11
	// assert buf == RopeBuffer{
	// 	root: &RopeNode{
	// 		data: gap.GapBuffer.new()
	// 	}
	// }

	mut count := 0
	mut nodes := []&RopeNode{}
	in_order(buf.root, mut nodes)
	for node in nodes {
		if node.data != none {
			count += 1
		}
	}

	// current split is incorrect
	assert count == 7
}
