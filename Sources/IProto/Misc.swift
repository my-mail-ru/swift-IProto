import Glibc

extension FloatingPoint {
	init(_ time: timeval) {
		self = Self(time.tv_sec) + Self(time.tv_usec) / 1000000
	}
}

extension timeval {
	init(_ time: Double) {
		tv_sec = Int(time)
		tv_usec = Int((time - Double(tv_sec)) * 1000000)
	}
}
