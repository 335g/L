//  Copyright © 2016 Yoshiki Kudo. All rights reserved.

///
/// These are implemented the [typelift/Focus](https://github.com/typelift/Focus) to the reference.

import XCTest
import L
import SwiftCheck
import Either

class LPrismSpec: XCTestCase {
	func testPrismLaws() {
		property("right identity") <- forAll { (fs: IsoOf<Int, UInt>) in
			let tryGet: (Int) -> Either<Int, UInt> = { arc4random() % 4 == 0 ? .right(fs.getTo($0)) : .left(0) }
			let prism = LPrism(tryGet: tryGet, reverseGet: fs.getFrom)
			
			return forAll { (i: Int) in
				let m = prism.modify(i, as: { $0 })
				
				return m == i || m == 0
			}
		}
	}
}

class PrismSpec: XCTestCase {
	func testPrismLaws() {
		property("right identity") <- forAll { (fs: IsoOf<Int, UInt>) in
			let tryGet: (Int) -> Either<Int, UInt> = { arc4random() % 4 == 0 ? .right(fs.getTo($0)) : .left(0) }
			let prism = Prism(tryGet: tryGet, reverseGet: fs.getFrom)
			
			return forAll { (i: Int) in
				let m = prism.modify(i, as: { $0 })
				
				return m == i || m == 0
			}
		}
	}
}
