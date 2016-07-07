//  Copyright © 2016 Yoshiki Kudo. All rights reserved.

// MARK: - GetterType

public protocol GetterType: SimpleOpticsType {
	func get(from: Source) -> Target
}
