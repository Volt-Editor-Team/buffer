module rope

import gap

fn test_iterator() {
	mut buf := RopeBuffer{
		root:     &RopeNode{
			data: gap.GapBuffer.new()
		}
		node_cap: 2
	}
	buf.insert(0, 'hello world')
}
