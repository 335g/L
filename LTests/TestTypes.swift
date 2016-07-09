//  Copyright © 2016 Yoshiki Kudo. All rights reserved.

import Himotoki

struct Person: Equatable {
	let fullName: String
	
	var json: String {
		return "{\"fullName\":\"\(fullName)\"}"
	}
}

struct Company: Equatable {
	let name: String
	let employees: [Person]
	
	var json: String {
		let employeesString = employees.reduce(""){ x, person in
			var comma = ""
			if x != "" { comma = "," }
			
			return x + comma + person.json
		}
		
		return "{\"name\": \"\(name)\", \"employees\": " + employeesString + "}"
	}
}

func == (lhs: Person, rhs: Person) -> Bool {
	return lhs.fullName == rhs.fullName
}

func == (lhs: Company, rhs: Company) -> Bool {
	let lhsSorted = lhs.employees.sorted(isOrderedBefore: { $0.fullName > $1.fullName })
	let rhsSorted = rhs.employees.sorted(isOrderedBefore: { $0.fullName > $1.fullName })
	let sameEmployees: Bool = zip(lhsSorted, rhsSorted).reduce(true){ $0 && $1.0 == $1.1 }

	return lhs.name == rhs.name && lhs.employees.count == rhs.employees.count && sameEmployees
}

extension Person: Decodable {
	static func decode(_ e: Extractor) throws -> Person {
		return try Person(fullName: e <| "fullname")
	}
}

extension Company: Decodable {
	static func decode(_ e: Extractor) throws -> Company {
		return try Company(
			name: e <| "name",
			employees: e <|| "employees"
		)
	}
}
