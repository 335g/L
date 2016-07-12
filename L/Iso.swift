//  Copyright © 2016 Yoshiki Kudo. All rights reserved.

import Bass

// MARK: - IsoType

public protocol IsoType: OpticsType {
	func get(from: Source) -> Target
	func reverseGet(from: AltTarget) -> AltSource
	init(get: (Source) -> Target, reverseGet: (AltTarget) -> AltSource)
}

public extension IsoType {
	public func modify(_ x: Source, as f: (Target) -> AltTarget) -> AltSource {
		return (reverseGet • f • get)(x)
	}
	
	public func set(_ y: AltTarget, to x: Source) -> AltSource {
		return modify(x, as: { _ in y })
	}
	
	public func tryGet(from: Source) -> Either<AltSource, Target> {
		return .right(get(from: from))
	}
}

public extension IsoType {
	public func split<S1, T1, A1, B1, I1: IsoType, I2: IsoType where I1.Source == S1, I1.AltSource == T1, I1.Target == A1, I1.AltTarget == B1, I2.Source == (Source, S1), I2.AltSource == (AltSource, T1), I2.Target == (Target, A1), I2.AltTarget == (AltTarget, B1)>(_ other: I1) -> I2 {
		
		let get: (Source, S1) -> (Target, A1) = {
			(self.get(from: $0), other.get(from: $1))
		}
		let reverseGet: (AltTarget, B1) -> (AltSource, T1) = {
			(self.reverseGet(from: $0), other.reverseGet(from: $1))
		}
		
		return I2(get: get, reverseGet: reverseGet)
	}
	
	public func first<T, I: IsoType where I.Source == (Source, T), I.AltSource == (AltSource, T), I.Target == (Target, T), I.AltTarget == (AltTarget, T)>() -> I {
		
		return I(
			get: { (s, t) in (self.get(from: s), t) },
			reverseGet: { (s, t) in (self.reverseGet(from: s), t) }
		)
	}
	
	public func second<T, I: IsoType where I.Source == (T, Source), I.AltSource == (T, AltSource), I.Target == (T, Target), I.AltTarget == (T, AltTarget)>() -> I {
		
		return I(
			get: { (t, s) in (t, self.get(from: s)) },
			reverseGet: { (t, s) in (t, self.reverseGet(from: s)) }
		)
	}
}

public extension IsoType {
	public var asLLens: LLens<Source, AltSource, Target, AltTarget> {
		return LLens(get: get, set: set)
	}
	
	public var asLPrism: LPrism<Source, AltSource, Target, AltTarget> {
		return LPrism(tryGet: tryGet, reverseGet: reverseGet)
	}
	
	public var asLSetter: LSetter<Source, AltSource, Target, AltTarget> {
		return LSetter(modify: modify)
	}
	
	public var asGetter: Getter<Source, Target> {
		return Getter(get: get)
	}
}

public extension IsoType where Source == AltSource, Target == AltTarget {
	public var asLens: Lens<Source, Target> {
		return Lens(get: get, set: set)
	}
	
	public var asPrism: Prism<Source, Target> {
		return Prism(tryGet: tryGet, reverseGet: reverseGet)
	}
	
	public var asSetter: Setter<Source, Target> {
		return Setter(modify: modify)
	}
	
	public var asIso: Iso<Source, Target> {
		return Iso(get: get, reverseGet: reverseGet)
	}
}

// MARK: - LIso

public struct LIso<S, T, A, B> {
	private let _get: (S) -> A
	private let _reverseGet: (B) -> T
	
	public init(get: (S) -> A, reverseGet: (B) -> T) {
		_get = get
		_reverseGet = reverseGet
	}
}

extension LIso: IsoType {
	public typealias Source = S
	public typealias AltSource = T
	public typealias Target = A
	public typealias AltTarget = B
	
	public func get(from: S) -> A {
		return _get(from)
	}
	
	public func reverseGet(from: B) -> T {
		return _reverseGet(from)
	}
}

public extension LIso {
	public var reverse: LIso<B, A, T, S> {
		return LIso<B, A, T, S>(get: _reverseGet, reverseGet: _get)
	}
}

// MARK: - Iso

public struct Iso<S, A> {
	private let _get: (S) -> A
	private let _reverseGet: (A) -> S
	
	public init(get: (S) -> A, reverseGet: (A) -> S) {
		_get = get
		_reverseGet = reverseGet
	}
}

extension Iso: IsoType {
	public typealias Source = S
	public typealias AltSource = S
	public typealias Target = A
	public typealias AltTarget = A
	
	public func get(from: S) -> A {
		return _get(from)
	}
	
	public func reverseGet(from: A) -> S {
		return _reverseGet(from)
	}
}

public extension Iso {
	public var reverse: Iso<A, S> {
		return Iso<A, S>(get: _reverseGet, reverseGet: _get)
	}
}
