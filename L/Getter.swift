//  Copyright © 2016 Yoshiki Kudo. All rights reserved.

import Bass

// MARK: - GetterType

public protocol GetterType: SimpleOpticsType {
	func get(from: Source) -> Target
}

public extension GetterType {
	public func split<S, A>(_ other: Getter<S, A>) -> Getter<(Source, S), (Target, A)> {
		return Getter(get: { (s1, s2) in (self.get(from: s1), other.get(from: s2)) })
	}
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
