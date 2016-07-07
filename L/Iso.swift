//  Copyright © 2016 Yoshiki Kudo. All rights reserved.

import Bass

// MARK: - IsoType

public protocol IsoType: PrismType, GetterType {}

public extension IsoType {
	public func modify(_ x: Source, as f: (Target) -> AltTarget) -> AltSource {
		return (reverseGet • f • get)(x)
	}
	
	public func tryGet(from: Source) -> Either<AltSource, Target> {
		return .right(get(from: from))
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
