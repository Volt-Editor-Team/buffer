module gap

import buffer { Buffer }
import math

const gap_bytes = 64

fn (g GapBuffer) split() (Buffer, Buffer) {
	text := g.get_runes()
	split := text.len / 2
	left := GapBuffer.from(text[..split])
	right := GapBuffer.from(text[split..])
	return left, right
}

fn (g GapBuffer) get_runes() []rune {
	return []rune{len: g.data.len - (g.gap.end - g.gap.start), init: if index >= g.gap.start {
		g.data[index + (g.gap.end - g.gap.start)]
	} else {
		g.data[index]
	}}
}

pub fn (g GapBuffer) debug_string() string {
	before := g.data[..g.gap.start]
	after := g.data[g.gap.end..]
	gap_len := g.gap.end - g.gap.start
	capacity := g.data.cap - gap_len - (before.len + after.len)
	return '${before.string()}[gap: ${gap_len}]${after.string()}\ncapacity: ${capacity}'
}

// gap memcpy
fn (mut g GapBuffer) shift_gap_to(curs int) {
	gap_len := g.gap.end - g.gap.start
	cursor := math.min(math.max(curs, 0), g.data.len - gap_len)
	if cursor == g.gap.start {
		return
	}
	if g.gap.start < cursor {
		// gap is before the cursor
		delta := cursor - g.gap.start
		for i in 0 .. delta {
			g.data[g.gap.start + i] = g.data[g.gap.end + i]
		}
		g.gap.start += delta
		g.gap.end += delta
	} else if g.gap.start > cursor {
		delta := g.gap.start - cursor
		for i := delta - 1; i >= 0; i-- {
			g.data[g.gap.end - delta + i] = g.data[cursor + i]
		}
		g.gap.start -= delta
		g.gap.end -= delta
	}
}

// reallocation on gap too small
fn check_gap_size(mut g GapBuffer, n_required int) {
	gap_len := g.gap.end - g.gap.start
	if gap_len < n_required {
		g.shift_gap_to(g.data.len - gap_len)
		if g.data.cap < g.data.len + n_required {
			g.data.grow_cap(2 * math.max(g.data.len, gap_bytes))
		}
		unsafe { g.data.grow_len(gap_bytes) }
		g.gap.end = g.data.len
	}
}
