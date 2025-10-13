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
	assert buf == RopeBuffer{
		root: &RopeNode{
			data: gap.GapBuffer.new()
		}
	}

	mut num_nodes := 0
	for node in buf.rope_iter() {
		num_nodes += 1
	}

	assert num_nodes == 6
}
