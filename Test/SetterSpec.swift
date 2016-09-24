//  Copyright © 2016 Yoshiki Kudo. All rights reserved.

///
/// These are implemented the [typelift/Focus](https://github.com/typelift/Focus) to the reference.

import XCTest
import Prelude
import L
import SwiftCheck

class LSetterSpec: XCTestCase {
	func testSetterLaws() {
		property("identity") <- forAll { (fs: IsoOf<Int, UInt>) in
			let lens = Lens(get: fs.getTo, set: { x, _ in fs.getFrom(x) })
			let setter = LSetter(modify: lens.modify)
			
			return forAll { (i: Int) in
				return setter.modify(i, as: { $0 }) == i
			}
		}
		
		property("associativity") <- forAll { (fs: IsoOf<Int, UInt>) in
			let lens = Lens(get: fs.getTo, set: { x, _ in fs.getFrom(x) })
			let setter = LSetter(modify: lens.modify)
			
			let f : (UInt) -> UInt = { $0 * 1 }
			let g : (UInt) -> UInt = { $0 + 2 }
			
			let mod: (@escaping (UInt) -> UInt) -> (Int) -> Int = { fn in { i in setter.modify(i, as: fn) }}
			
			return forAll { (i: Int) in
				return (mod(f) <<< mod(g))(i) == mod(f <<< g)(i)
			}
		}
	}
}

class SetterSpec: XCTestCase {
	func testSetterLaws() {
		property("identity") <- forAll { (fs: IsoOf<Int, UInt>) in
			let lens = Lens(get: fs.getTo, set: { x, _ in fs.getFrom(x) })
			let setter = Setter<Int, UInt>(modify: lens.modify)
			
			return forAll { (i: Int) in
				return setter.modify(i, as: { $0 }) == i
			}
		}
		
		property("associativity") <- forAll { (fs: IsoOf<Int, UInt>) in
			let lens = Lens(get: fs.getTo, set: { x, _ in fs.getFrom(x) })
			let setter = Setter<Int, UInt>(modify: lens.modify)
			
			let f : (UInt) -> UInt = { $0 * 1 }
			let g : (UInt) -> UInt = { $0 + 2 }
			
			let mod: (@escaping (UInt) -> UInt) -> (Int) -> Int = { fn in { i in setter.modify(i, as: fn) }}
			
			return forAll { (i: Int) in
				return (mod(f) <<< mod(g))(i) == mod(f <<< g)(i)
			}
		}
	}
}
