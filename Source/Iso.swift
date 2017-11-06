//  Copyright © 2016 Yoshiki Kudo. All rights reserved.

import Either

// MARK: - LIso

///
/// An isomorphism between S, A and B, T
///
/// - parameter S: The source of the first function of the isomorphism
/// - parameter T: The target of the second function of the isomorphism
/// - parameter A: The target of the first function of the isomorphism
/// - parameter B: The source of the second function of the isomorphism
public struct LIso<S, T, A, B> {
	fileprivate let _get: (S) -> A
	fileprivate let _reverseGet: (B) -> T
	
	public init(get: @escaping (S) -> A, reverseGet: @escaping (B) -> T) {
		_get = get
		_reverseGet = reverseGet
	}
}

extension LIso {
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
public typealias Iso<S, A> = LIso<S, S, A, A>

// MARK: - IsoProtocol

public protocol IsoProtocol: PrismProtocol, LensProtocol {
	func reverseGet(from: AltTarget) -> AltSource
}

extension LIso: IsoProtocol {
    public typealias Source = S
    public typealias AltSource = T
    public typealias Target = A
    public typealias AltTarget = B
    
    public func get(from source: S) -> A {
        return _get(source)
    }
    
    public func reverseGet(from: B) -> T {
        return _reverseGet(from)
    }
}

public extension IsoProtocol {
	public func tryGet(from: Source) -> Either<AltSource, Target> {
		return .right(get(from: from))
	}
}

extension IsoProtocol {
    public func split<I>(_ other: I) -> LIso<(Source, I.Source), (AltSource, I.AltSource), (Target, I.Target), (AltTarget, I.AltTarget)> where I: IsoProtocol {
        return LIso<(Source, I.Source), (AltSource, I.AltSource), (Target, I.Target), (AltTarget, I.AltTarget)>(
            get: { (self.get(from: $0), other.get(from: $1)) },
            reverseGet: { (self.reverseGet(from: $0), other.reverseGet(from: $1)) })
    }
    
    public func first<T>() -> LIso<(Source, T), (AltSource, T), (Target, T), (AltTarget, T)> {
        return LIso<(Source, T), (AltSource, T), (Target, T), (AltTarget, T)>(
            get: { (s, t) in (self.get(from: s), t) },
            reverseGet: { (s, t) in (self.reverseGet(from: s), t) })
    }
    
    public func second<T>() -> LIso<(T, Source), (T, AltSource), (T, Target), (T, AltTarget)> {
        return LIso<(T, Source), (T, AltSource), (T, Target), (T, AltTarget)>(
            get: { (t, s) in (t, self.get(from: s)) },
            reverseGet: { (t, s) in (t, self.reverseGet(from: s)) })
    }
    
    public func left<T>() -> LIso<Either<Source, T>, Either<AltSource, T>, Either<Target, T>, Either<AltTarget, T>> {
        return LIso<Either<Source, T>, Either<AltSource, T>, Either<Target, T>, Either<AltTarget, T>>(
            get: { $0.mapLeft(self.get) },
            reverseGet: { $0.mapLeft(self.reverseGet) })
    }
    
    public func right<T>() -> LIso<Either<T, Source>, Either<T, AltSource>, Either<T, Target>, Either<T, AltTarget>> {
        return LIso<Either<T, Source>, Either<T, AltSource>, Either<T, Target>, Either<T, AltTarget>>(
            get: { $0.map(self.get) },
            reverseGet: { $0.map(self.reverseGet) })
    }
}

public extension IsoProtocol {
	public var iso: LIso<Source, AltSource, Target, AltTarget> {
		return LIso(get: get, reverseGet: reverseGet)
	}
	
	public var lens: LLens<Source, AltSource, Target, AltTarget> {
		return LLens(get: get, set: set)
	}
	
	public var prism: LPrism<Source, AltSource, Target, AltTarget> {
		return LPrism(tryGet: tryGet, reverseGet: reverseGet)
	}
	
	public var setter: LSetter<Source, AltSource, Target, AltTarget> {
		return LSetter(modify: modify)
	}
	
	public var getter: Getter<Source, Target> {
		return Getter(get: get)
	}
}
