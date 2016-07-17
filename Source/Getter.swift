//  Copyright © 2016 Yoshiki Kudo. All rights reserved.

import Bass

// MARK: - GetterProtocol

public protocol GetterProtocol: SimpleOpticsType {
	func get(from: Source) -> Target
}

// MARK: - GetterGenerator

public protocol GetterGenerator: GetterProtocol {
	init(get: (Source) -> Target)
}

public extension GetterGenerator {
	public func split <S, A, G1: GetterGenerator, G2: GetterGenerator where
		G1.Source == S,
		G1.Target == A,
		G2.Source == (Source, S),
		G2.Target == (Target, A)> (_ other: G1) -> G2
	{
		return G2(get:
			{ (s1, s2) in
				(self.get(from: s1), other.get(from: s2))
			}
		)
	}
	
	public func choice <S, G1: GetterGenerator, G2: GetterGenerator where
		G1.Source == S,
		G1.Target == Target,
		G2.Source == Either<Source, S>,
		G2.Target == Target> (_ other: G1) -> G2
	{
		return G2(get: { $0.either(ifLeft: self.get, ifRight: other.get) })
	}
	
	public func first <T, G: GetterGenerator where G.Source == (Source, T), G.Target == (Target, T)>() -> G {
		return G(get: { (s, t) in (self.get(from: s), t) })
	}
	
	public func second <T, G: GetterGenerator where G.Source == (T, Source), G.Target == (T, Target)>() -> G {
		return G(get: { (t, s) in (t, self.get(from: s)) })
	}
	
	public func left <T, G: GetterGenerator where G.Source == Either<Source, T>, G.Target == Either<Target, T>>() -> G {
		return G(get: { $0.map(self.get) })
	}
	
	public func right <T, G: GetterGenerator where G.Source == Either<T, Source>, G.Target == Either<T, Target>>() -> G {
		return G(get: { $0.map(self.get) })
	}
}

// MARK: - Getter

///
/// A `Getter` is equal to getter method.
///
/// - parameter S: source
/// - parameter A: target
public struct Getter<S, A> {
	private let _get: (S) -> A
	
	public init(get: (S) -> A) {
		_get = get
	}
}

extension Getter: GetterGenerator {
	public typealias Source = S
	public typealias Target = A
	
	public func get(from: S) -> A {
		return _get(from)
	}
}
