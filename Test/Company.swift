//  Copyright © 2016 Yoshiki Kudo. All rights reserved.

import XCTest
import Prelude
import L

struct Company {
	let _employer: Person
	
	static var employer: Lens<Company, Person> {
		let getter: (Company) -> Person = { $0._employer }
		let setter: (Person, Company) -> Company = { newPerson, company in
			return Company(_employer: newPerson)
		}
		
		return Lens(get: getter, set: setter)
	}
}

class CompanySpec: XCTestCase {
	func testeEmployerLens() {
		let company = Company(_employer: Person(_name: "Steve Jobs", _age: 19))
		let nameLens = Company.employer >>> Person.name
		
		XCTAssert(nameLens.get(from: company) == "Steve Jobs")
		
		let updatedCompany = (Company.employer >>> Person.name).set("John Sculley", to: company)
		XCTAssert(nameLens.get(from: updatedCompany) == "John Sculley")
	}
}
