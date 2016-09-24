//  Copyright © 2016 Yoshiki Kudo. All rights reserved.

///
/// These are implemented the [typelift/Focus](https://github.com/typelift/Focus) to the reference.

import XCTest
import L
import SwiftCheck

class LLensSpec: XCTestCase {
	func testLensLaws() {
		property("get -> set") <- forAll { (fs: IsoOf<Int, UInt>) in
			let lens = LLens(get: fs.getTo, set: { x, _ in fs.getFrom(x) })
			return forAll { (i: Int) in
				lens.set(lens.get(from: i), to: i) == i
			}
		}
		
		property("set -> get") <- forAll { (fs: IsoOf<Int, UInt>) in
			let lens = LLens(get: fs.getTo, set: { x, _ in fs.getFrom(x) })
			return forAll { (i: Int, ui: UInt) in
				lens.get(from: lens.set(ui, to: i)) == ui
			}
		}
		
		property("idempotent set") <- forAll { (fs: IsoOf<Int, UInt>) in
			let lens = LLens(get: fs.getTo, set: { x, _ in fs.getFrom(x) })
			return forAll { (i: Int, ui1: UInt, ui2: UInt) in
				let to = lens.set(ui2, to: i)
				return lens.set(ui1, to: to) == lens.set(ui1, to: i)
			}
		}
		
		property("idempotent identity") <- forAll { (fs: IsoOf<Int, UInt>) in
			let lens = LLens(get: fs.getTo, set: { x, _ in fs.getFrom(x) })
			return forAll { (i: Int) in
				lens.modify(i, as: { $0 }) == i
			}
		}
	}
}

class LensSpec: XCTestCase {
	func testLensLaws() {
		property("get -> set") <- forAll { (fs: IsoOf<Int, UInt>) in
			let lens = Lens(get: fs.getTo, set: { x, _ in fs.getFrom(x) })
			return forAll { (i: Int) in
				lens.set(lens.get(from: i), to: i) == i
			}
		}
		
		property("set -> get") <- forAll { (fs: IsoOf<Int, UInt>) in
			let lens = Lens(get: fs.getTo, set: { x, _ in fs.getFrom(x) })
			return forAll { (i: Int, ui: UInt) in
				lens.get(from: lens.set(ui, to: i)) == ui
			}
		}
		
		property("idempotent set") <- forAll { (fs: IsoOf<Int, UInt>) in
			let lens = Lens(get: fs.getTo, set: { x, _ in fs.getFrom(x) })
			return forAll { (i: Int, ui1: UInt, ui2: UInt) in
				let to = lens.set(ui2, to: i)
				return lens.set(ui1, to: to) == lens.set(ui1, to: i)
			}
		}
		
		property("idempotent identity") <- forAll { (fs: IsoOf<Int, UInt>) in
			let lens = Lens(get: fs.getTo, set: { x, _ in fs.getFrom(x) })
			return forAll { (i: Int) in
				lens.modify(i, as: { $0 }) == i
			}
		}
	}
}
