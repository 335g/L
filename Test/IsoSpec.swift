//  Copyright © 2016 Yoshiki Kudo. All rights reserved.

///
/// These are implemented the [typelift/Focus](https://github.com/typelift/Focus) to the reference.

import XCTest
import Prelude
import L
import SwiftCheck

class IsoSpec: XCTestCase {
	func testIsoLaws() {
		property("round") <- forAll { (ui: UInt, fs: IsoOf<Int, UInt>) in
			let iso = Iso(get: fs.getTo, reverseGet: fs.getFrom)
			return iso.get(from: iso.reverseGet(from: ui)) == ui
		}
		
		property("reverse around") <- forAll { (i: Int, fs: IsoOf<Int, UInt>) in
			let iso = Iso(get: fs.getTo, reverseGet: fs.getFrom)
			return iso.reverseGet(from: iso.get(from: i)) == i
		}
		
		property("identity") <- forAll { (i: Int, fs: IsoOf<Int, UInt>) in
			let iso = Iso(get: fs.getTo, reverseGet: fs.getFrom)
			return iso.modify(i, as: { $0 }) == i
		}
		
		property("associativity (get)") <- forAll { (i: Int, fs: IsoOf<Int, Int>, gs: IsoOf<Int, Int>) in
			let iso1 = Iso(get: fs.getTo, reverseGet: fs.getFrom)
			let iso2 = Iso(get: gs.getTo, reverseGet: gs.getFrom)
			return iso2.get(from: iso1.get(from: i)) == (iso1 >>> iso2).get(from: i)
		}
		
		property("associativity (reverseGet)") <- forAll { (i: Int, fs: IsoOf<Int, Int>, gs: IsoOf<Int, Int>) in
			let iso1 = Iso(get: fs.getTo, reverseGet: fs.getFrom)
			let iso2 = Iso(get: gs.getTo, reverseGet: gs.getFrom)
			return iso1.reverseGet(from: iso2.reverseGet(from: i)) == (iso1 >>> iso2).reverseGet(from: i)
		}
	}
	
	func testIsoInverseLaws() {
		property("round") <- forAll { (ui: UInt, fs: IsoOf<Int, UInt>) in
			let iso = Iso(get: fs.getTo, reverseGet: fs.getFrom).reverse.reverse
			return iso.get(from: iso.reverseGet(from: ui)) == ui
		}
		
		property("reverse around") <- forAll { (i: Int, fs: IsoOf<Int, UInt>) in
			let iso = Iso(get: fs.getTo, reverseGet: fs.getFrom).reverse.reverse
			return iso.reverseGet(from: iso.get(from: i)) == i
		}
		
		property("identity") <- forAll { (i: Int, fs: IsoOf<Int, UInt>) in
			let iso = Iso(get: fs.getTo, reverseGet: fs.getFrom).reverse.reverse
			return iso.modify(i, as: { $0 }) == i
		}
		
		property("associativity (get)") <- forAll { (i: Int, fs: IsoOf<Int, Int>, gs: IsoOf<Int, Int>) in
			let iso1 = Iso(get: fs.getTo, reverseGet: fs.getFrom).reverse.reverse
			let iso2 = Iso(get: gs.getTo, reverseGet: gs.getFrom).reverse.reverse
			return iso2.get(from: iso1.get(from: i)) == (iso1 >>> iso2).get(from: i)
		}
		
		property("associativity (reverseGet)") <- forAll { (i: Int, fs: IsoOf<Int, Int>, gs: IsoOf<Int, Int>) in
			let iso1 = Iso(get: fs.getTo, reverseGet: fs.getFrom).reverse.reverse
			let iso2 = Iso(get: gs.getTo, reverseGet: gs.getFrom).reverse.reverse
			return iso1.reverseGet(from: iso2.reverseGet(from: i)) == (iso1 >>> iso2).reverseGet(from: i)
		}
	}
}
