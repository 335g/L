//  Copyright © 2016 Yoshiki Kudo. All rights reserved.

import L

struct Person: Equatable {
	let _name: String
	let _age: Int
	
	static var name: Lens<Person, String> {
		let getter: (Person) -> String = { $0._name }
		let setter: (String, Person) -> Person = { newName, person in
			return Person(_name: newName, _age: person._age)
		}
		
		return Lens(get: getter, set: setter)
	}
}

func == (lhs: Person, rhs: Person) -> Bool {
	return lhs._name == rhs._name && lhs._age == rhs._age
}
