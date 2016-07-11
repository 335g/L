//  Copyright © 2016 Yoshiki Kudo. All rights reserved.

import Bass

// MARK: - GetterType

public protocol GetterType: SimpleOpticsType {
	func get(from: Source) -> Target
	init(get: (Source) -> Target)
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

public extension Getter {
	public func first<T>() -> Getter<(S, T), (A, T)> {
		return Getter<(S, T), (A, T)>(get: { (s, t) in (self.get(from: s), t) })
	}
	
	public func second<T>() -> Getter<(T, S), (T, A)> {
		return Getter<(T, S), (T, A)>(get: { (t, s) in (t, self.get(from: s)) })
	}
	
	public func left<T>() -> Getter<Either<S, T>, Either<A, T>> {
		return Getter<Either<S, T>, Either<A, T>>(get: { $0.map(self.get) })
	}
	
	public func right<T>() -> Getter<Either<T, S>, Either<T, A>> {
		return Getter<Either<T, S>, Either<T, A>>(get: { $0.map(self.get) })
	}
}
