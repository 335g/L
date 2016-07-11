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
