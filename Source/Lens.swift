//  Copyright © 2016 Yoshiki Kudo. All rights reserved.

// MARK: - LensProtocol

public protocol LensProtocol: GetterProtocol, SetterProtocol {}

// MARK: - LensGenerator

public protocol LensGenerator: LensProtocol {
	init(get: (Source) -> Target, set: (AltTarget, Source) -> AltSource)
}

public extension LensGenerator {
	public func split <S1, T1, A1, B1, L1: LensGenerator, L2: LensGenerator where
		L1.Source		== S1,
		L1.AltSource	== T1,
		L1.Target		== A1,
		L1.AltTarget	== B1,
		L2.Source		== (Source, S1),
		L2.AltSource	== (AltSource, T1),
		L2.Target		== (Target, A1),
		L2.AltTarget	== (AltTarget, B1)> (_ other: L1) -> L2
	{
		let get: (Source, S1) -> (Target, A1) = {
			(self.get(from: $0), other.get(from: $1))
		}
		let set: ((AltTarget, B1), (Source, S1)) -> (AltSource, T1) = { (t0, t1) in
			(self.set(t0.0, to: t1.0), other.set(t0.1, to: t1.1))
		}
		return L2(get: get,set: set)
	}
	
	public func first <T, L: LensGenerator where
		L.Source	== (Source, T),
		L.AltSource == (AltSource, T),
		L.Target	== (Target, T),
		L.AltTarget == (AltTarget, T)> () -> L
	{
		let set: ((AltTarget, T), (Source, T)) -> (AltSource, T) = { (t0, t1) in
			(self.set(t0.0, to: t1.0), t0.1)
		}
		
		return L(
			get: { (s, t) in (self.get(from: s), t) },
			set: set
		)
	}
	
	public func second <T, L: LensGenerator where
		L.Source	== (T, Source),
		L.AltSource == (T, AltSource),
		L.Target	== (T, Target),
		L.AltTarget == (T, AltTarget)> () -> L
	{
		let set: ((T, AltTarget), (T, Source)) -> (T, AltSource) = { (t0, t1) in
			(t0.0, self.set(t0.1, to: t1.1))
		}
		
		return L(
			get: { (t, s) in (t, self.get(from: s)) },
			set: set
		)
	}
}

public extension LensGenerator {
	public var asLSetter: LSetter<Source, AltSource, Target, AltTarget> {
		return LSetter(modify: modify)
	}
	
	public var asLLens: LLens<Source, AltSource, Target, AltTarget> {
		return LLens(get: get, set: set)
	}
	
	public var asGetter: Getter<Source, Target> {
		return Getter(get: get)
	}
}

public extension LensGenerator where Source == AltSource, Target == AltTarget {
	public var asSetter: Setter<Source, Target> {
		return Setter(modify: modify)
	}
	
	public var asLens: Lens<Source, Target> {
		return Lens(get: get, set: set)
	}
}

// MARK: - LLens

public struct LLens<S, T, A, B> {
	private let _get: (S) -> A
	private let _set: (B, S) -> T
	
	public init(get: (S) -> A, set: (B, S) -> T) {
		_get = get
		_set = set
	}
}

extension LLens: LensGenerator {
	public typealias Source = S
	public typealias AltSource = T
	public typealias Target = A
	public typealias AltTarget = B
	
	public func get(from: S) -> A {
		return _get(from)
	}
	
	public func modify(_ x: S, as f: (A) -> B) -> T {
		return _set(f(_get(x)), x)
	}
	
	public func set(_ y: B, to x: S) -> T {
		return _set(y, x)
	}
}

// MARK: - Lens

public struct Lens<S, A> {
	private let _get: (S) -> A
	private let _set: (A, S) -> S
	
	public init(get: (S) -> A, set: (A, S) -> S) {
		_get = get
		_set = set
	}
}

extension Lens: LensGenerator {
	public typealias Source = S
	public typealias AltSource = S
	public typealias Target = A
	public typealias AltTarget = A
	
	public func get(from: S) -> A {
		return _get(from)
	}
	
	public func modify(_ x: S, as f: (A) -> A) -> S {
		return _set(f(_get(x)), x)
	}
	
	public func set(_ y: A, to x: S) -> S {
		return _set(y, x)
	}
}
