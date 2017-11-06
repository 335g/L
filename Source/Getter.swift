//  Copyright © 2016 Yoshiki Kudo. All rights reserved.

import Either

// MARK: - Getter

///
/// A `Getter` is equal to getter method.
///
/// - parameter S: source
/// - parameter A: target
public struct Getter<S, A> {
	fileprivate let _get: (S) -> A
	
	public init(get: @escaping (S) -> A) {
		_get = get
	}
}

// MARK: - GetterProtocol

public protocol GetterProtocol: SimpleOpticsProtocol {
	func get(from source: Source) -> Target
}

extension Getter: GetterProtocol {
    public typealias Source = S
    public typealias Target = A
    
    public func get(from source: S) -> A {
        return _get(source)
    }
}

extension Getter {
    public func split<G>(_ other: G) -> Getter<(Source, G.Source), (Target, G.Target)> where G: GetterProtocol {
        return Getter<(Source, G.Source), (Target, G.Target)>(get: { (s1, s2) in
            (self.get(from: s1), other.get(from: s2))
        })
    }
    
    public func choice<G>(_ other: G) -> Getter<Either<Source, G.Source>, Target> where G: GetterProtocol, G.Target == Target {
        return Getter<Either<Source, G.Source>, Target>(get: { $0.either(ifLeft: self.get, ifRight: other.get) })
    }
    
    public func first<T>() -> Getter<(Source, T), (Target, T)> {
        return Getter<(Source, T), (Target, T)>(get: { (s, t) in
            (self.get(from: s), t)
        })
    }
    
    public func second<T>() -> Getter<(T, Source), (T, Target)> {
        return Getter<(T, Source), (T, Target)>(get: { (t, s) in
            (t, self.get(from: s))
        })
    }
    
    public func left<T>() -> Getter<Either<Source, T>, Either<Target, T>> {
        return Getter<Either<Source, T>, Either<Target, T>>(get: { $0.mapLeft(self.get) })
    }
    
    public func right<T>() -> Getter<Either<T, Source>, Either<T, Target>> {
        return Getter<Either<T, Source>, Either<T, Target>>(get: { $0.map(self.get) })
    }
}
