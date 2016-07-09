//  Copyright © 2016 Yoshiki Kudo. All rights reserved.

import Foundation
import XCTest
import Himotoki
@testable import L

class PrismTest: XCTestCase {
	
	let input1 = "{\"fullname\": \"John Smith\"}"
	let input2 = "{\"name\": \"Enterprise Inc.\", \"employees\": [{\"fullname\": \"William Reddington Hewlett\"},{\"fullname\": \"David Packard\"}]}"
	
	func tryGet<T: Decodable>(type: T.Type) -> (String) -> T? {
		return { str in
			if let
				data = str.data(using: String.Encoding.unicode),
				serialized = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
				json = serialized as? [String : AnyObject]
			{
				return try? T.decodeValue(json)
			}
			
			return nil
		}
	}
	
	func testPrism(){
		let prism: Prism<String, Person> = .prism(tryGet: tryGet(type: Person.self), reverseGet: { $0.json })
		XCTAssert(prism.tryGet(from: input1).isRight)
		XCTAssert(prism.tryGet(from: input2).isLeft)
		
		let prism2: Prism<String, Company> = .prism(tryGet: tryGet(type: Company.self), reverseGet: { $0.json })
		XCTAssert(prism2.tryGet(from: input1).isLeft)
		XCTAssert(prism2.tryGet(from: input2).isRight)
	}
}

