//  Copyright © 2016 Yoshiki Kudo. All rights reserved.

// MARK: - GetterType

public protocol GetterType: SimpleOpticsType {
	func get(from: Source) -> Target
}

// MARK: - Getter

public struct Getter<S, A> {
	private let _get: (S) -> A
	
	public init(get: (S) -> A) {
		_get = get
	}
}

extension Getter: GetterType {
	public typealias Source = S
	public typealias Target = A
	
	public func get(from: S) -> A {
		return _get(from)
	}
}
