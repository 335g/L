//  Copyright © 2016 Yoshiki Kudo. All rights reserved.

// MARK: - LensType

public protocol LensType: GetterType, SetterType {}

public extension LensType {
	public var asLSetter: LSetter<Source, AltSource, Target, AltTarget> {
		return LSetter(modify: modify)
	}
}

public extension LensType where Source == AltSource, Target == AltTarget {
	public var asSetter: Setter<Source, Target> {
		return Setter(modify: modify)
	}
	
	public var asGetter: Getter<Source, Target> {
		return Getter(get: get)
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

extension LLens: LensType {
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

extension Lens: LensType {
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
