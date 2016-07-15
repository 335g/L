//  Copyright © 2016 Yoshiki Kudo. All rights reserved.

import Bass

// MARK: - GetterType

public protocol GetterType: SimpleOpticsType {
	func get(from: Source) -> Target
	init(get: (Source) -> Target)
}

public extension GetterType {
	public func split<S, A, G: GetterType where G.Source == S, G.Target == A>(_ other: G) -> Getter<(Source, S), (Target, A)> {
		return Getter<(Source, S), (Target, A)>(get:
			{ (s1, s2) in
				(self.get(from: s1), other.get(from: s2))
			}
		)
	}
	
	public func choice<S, G: GetterType where G.Source == S, G.Target == Target>(_ other: G) -> Getter<Either<Source, S>, Target> {
		return Getter(get: { $0.either(ifLeft: self.get, ifRight: other.get) })
	}
	
	public func first<T>() -> Getter<(Source, T), (Target, T)> {
		return Getter(get: { (s, t) in (self.get(from: s), t) })
	}
	
	public func second<T>() -> Getter<(T, Source), (T, Target)> {
		return Getter(get: { (t, s) in (t, self.get(from: s)) })
	}
	
	public func left<T>() -> Getter<Either<Source, T>, Either<Target, T>> {
		return Getter(get: { $0.map(self.get) })
	}
	
	public func right<T>() -> Getter<Either<T, Source>, Either<T, Target>> {
		return Getter(get: { $0.map(self.get) })
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
