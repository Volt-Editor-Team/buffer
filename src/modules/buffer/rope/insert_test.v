module rope

import gap

fn test_insert() {
	mut buf := RopeBuffer.new(gap.GapBuffer.new())
	buf.insert(0, 'hello world')
	assert buf.to_string() == 'hello world'
}
