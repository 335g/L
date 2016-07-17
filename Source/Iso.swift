//  Copyright © 2016 Yoshiki Kudo. All rights reserved.

import Bass

// MARK: - IsoProtocol

public protocol IsoProtocol: PrismProtocol, LensProtocol {
	func reverseGet(from: AltTarget) -> AltSource
}

public extension IsoProtocol {
	public func tryGet(from: Source) -> Either<AltSource, Target> {
		return .right(get(from: from))
	}
}

// MARK: - IsoGenerator

public protocol IsoGenerator: IsoProtocol {
	init(get: (Source) -> Target, reverseGet: (AltTarget) -> AltSource)
}

public extension IsoGenerator {
	public func split <S1, T1, A1, B1, I1: IsoGenerator, I2: IsoGenerator where
		I1.Source		== S1,
		I1.AltSource	== T1,
		I1.Target		== A1,
		I1.AltTarget	== B1,
		I2.Source		== (Source, S1),
		I2.AltSource	== (AltSource, T1),
		I2.Target		== (Target, A1),
		I2.AltTarget	== (AltTarget, B1)> (_ other: I1) -> I2
	{
		return I2(
			get: { (self.get(from: $0), other.get(from: $1)) },
			reverseGet: { (self.reverseGet(from: $0), other.reverseGet(from: $1)) }
		)
	}
	
	public func first <T, I: IsoGenerator where
		I.Source	== (Source, T),
		I.AltSource == (AltSource, T),
		I.Target	== (Target, T),
		I.AltTarget == (AltTarget, T)> () -> I
	{
		return I(
			get: { (s, t) in (self.get(from: s), t) },
			reverseGet: { (s, t) in (self.reverseGet(from: s), t) }
		)
	}
	
	public func second <T, I: IsoGenerator where
		I.Source	== (T, Source),
		I.AltSource == (T, AltSource),
		I.Target	== (T, Target),
		I.AltTarget == (T, AltTarget)> () -> I
	{
		return I(
			get: { (t, s) in (t, self.get(from: s)) },
			reverseGet: { (t, s) in (t, self.reverseGet(from: s)) }
		)
	}
	
	public func left <T, I: IsoGenerator where
		I.Source	== Either<Source, T>,
		I.AltSource == Either<AltSource, T>,
		I.Target	== Either<Target, T>,
		I.AltTarget == Either<AltTarget, T>> () -> I
	{
		return I(
			get: { $0.map(self.get) },
			reverseGet: { $0.map(self.reverseGet) }
		)
	}
	
	public func right <T, I: IsoGenerator where
		I.Source	== Either<T, Source>,
		I.AltSource == Either<T, AltSource>,
		I.Target	== Either<T, Target>,
		I.AltTarget == Either<T, AltTarget>> () -> I
	{
		return I(
			get: { $0.map(self.get) },
			reverseGet: { $0.map(self.reverseGet) }
		)
	}
}

public extension IsoGenerator {
	public var asLIso: LIso<Source, AltSource, Target, AltTarget> {
		return LIso(get: get, reverseGet: reverseGet)
	}
	
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

public extension IsoGenerator where Source == AltSource, Target == AltTarget {
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

///
/// An isomorphism between S, A and B, T
///
/// - parameter S: The source of the first function of the isomorphism
/// - parameter T: The target of the second function of the isomorphism
/// - parameter A: The target of the first function of the isomorphism
/// - parameter B: The source of the second function of the isomorphism
public struct LIso<S, T, A, B> {
	private let _get: (S) -> A
	private let _reverseGet: (B) -> T
	
	public init(get: (S) -> A, reverseGet: (B) -> T) {
		_get = get
		_reverseGet = reverseGet
	}
}

extension LIso: IsoGenerator {
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

///
/// An isomorphism S, A
///
/// - parameter S: The source/target of the isomorphism
/// - parameter A: The target/source of the isomorphism
public struct Iso<S, A> {
	private let _get: (S) -> A
	private let _reverseGet: (A) -> S
	
	public init(get: (S) -> A, reverseGet: (A) -> S) {
		_get = get
		_reverseGet = reverseGet
	}
}

extension Iso: IsoGenerator {
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
