//  Copyright © 2017 Yoshiki Kudo. All rights reserved.

// MARK: - LLens

///
/// A `LLens` can be thought of as a reference to a subpart of a structure. (weaker `LIso`)
///
/// - parameter S: focused structure
/// - parameter T: modified form of the structure
/// - parameter A: result of retrieving the focused subpart
/// - parameter B: modification to make to the original structure
public struct LLens<S, T, A, B> {
	fileprivate let _get: (S) -> A
	fileprivate let _set: (B, S) -> T
	
	public init(get: @escaping (S) -> A, set: @escaping (B, S) -> T) {
		_get = get
		_set = set
	}
}

// MARK: - Lens

///
/// A `Lens` can be thought of as a reference to a subpart of a structure. (weaker `Iso`)
///
/// - parameter S:
/// - parameter A:
public typealias Lens<S, A> = LLens<S, S, A, A>

// MARK: - LensProtocol

public protocol LensProtocol: GetterProtocol, SetterProtocol {}

extension LLens: LensProtocol {
    public typealias Source = S
    public typealias AltSource = T
    public typealias Target = A
    public typealias AltTarget = B
    
    public func get(from source: S) -> A {
        return _get(source)
    }
    
    public func modify(_ x: S, as f: @escaping (A) -> B) -> T {
        return _set(f(_get(x)), x)
    }
    
    public func set(_ y: B, to x: S) -> T {
        return _set(y, x)
    }
}

extension LensProtocol {
    public func split<L>(_ other: L) -> LLens<(Source, L.Source), (AltSource, L.AltSource), (Target, L.Target), (AltTarget, L.AltTarget)> where L: LensProtocol {
        let set: ((AltTarget, L.AltTarget), (Source, L.Source)) -> (AltSource, L.AltSource) = { (t0, t1) in
            (self.set(t0.0, to: t1.0), other.set(t0.1, to: t1.1))
        }
        
        return LLens<(Source, L.Source), (AltSource, L.AltSource), (Target, L.Target), (AltTarget, L.AltTarget)>(
            get: { (self.get(from: $0), other.get(from: $1)) },
            set: set)
    }
    
    public func first<T>() -> LLens<(Source, T), (AltSource, T), (Target, T), (AltTarget, T)> {
        let set: ((AltTarget, T), (Source, T)) -> (AltSource, T) = { (t0, t1) in
            (self.set(t0.0, to: t1.0), t0.1)
        }
        
        return LLens<(Source, T), (AltSource, T), (Target, T), (AltTarget, T)>(
            get: { (s, t) in (self.get(from: s), t) },
            set: set)

    }
    
    public func second<T>() -> LLens<(T, Source), (T, AltSource), (T, Target), (T, AltTarget)> {
        let set: ((T, AltTarget), (T, Source)) -> (T, AltSource) = { (t0, t1) in
            (t0.0, self.set(t0.1, to: t1.1))
        }
        
        return LLens<(T, Source), (T, AltSource), (T, Target), (T, AltTarget)>(
            get: { (t, s) in (t, self.get(from: s)) },
            set: set)
    }
}

extension LensProtocol {
	public var setter: LSetter<Source, AltSource, Target, AltTarget> {
		return LSetter(modify: modify)
	}
	
	public var lens: LLens<Source, AltSource, Target, AltTarget> {
		return LLens(get: get, set: set)
	}
	
	public var getter: Getter<Source, Target> {
		return Getter(get: get)
	}
}
