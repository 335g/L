//  Copyright © 2016 Yoshiki Kudo. All rights reserved.

// MARK: - SetterType

public protocol SetterType: OpticsType {
	func modify(_ x: Source, as f: (Target) -> AltTarget) -> AltSource
}

public extension SetterType {
	public func set(_ y: AltTarget, to x: Source) -> AltSource {
		return modify(x, as: { _ in y })
	}
}
