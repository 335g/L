//  Copyright © 2016 Yoshiki Kudo. All rights reserved.

import Bass

// MARK: - PrismProtocol

public protocol PrismProtocol: SetterProtocol {
	func tryGet(from: Source) -> Either<AltSource, Target>
	func reverseGet(from: AltTarget) -> AltSource
}

public extension PrismProtocol {
	public func modify(_ x: Source, as f: (Target) -> AltTarget) -> AltSource {
		return tryGet(from: x).either(
			ifLeft: id,
			ifRight: reverseGet • f
		)
	}
	
	public var re: Getter<AltTarget, AltSource> {
		return Getter(get: reverseGet)
	}
}

// MARK: - PrismGenerator

public protocol PrismGenerator: PrismProtocol {
	init(tryGet: (Source) -> Either<AltSource, Target>, reverseGet: (AltTarget) -> AltSource)
}

public extension PrismGenerator {
	public func first <T, P: PrismGenerator where
		P.Source	== (Source, T),
		P.AltSource == (AltSource, T),
		P.Target	== (Target, T),
		P.AltTarget == (AltTarget, T)> () -> P
	{
		let tryGet: (Source, T) -> Either<(AltSource, T), (Target, T)> = { (s, x) in
			self.tryGet(from: s).bimap({ ($0, x) }, { ($0, x) })
		}
		
		return P (
			tryGet: tryGet,
			reverseGet: { (at, x) in (self.reverseGet(from: at), x) }
		)
	}
	
	public func second <T, P: PrismGenerator where
		P.Source	== (T, Source),
		P.AltSource == (T, AltSource),
		P.Target	== (T, Target),
		P.AltTarget == (T, AltTarget)> () -> P
	{
		let tryGet: (T, Source) -> Either<(T, AltSource), (T, Target)> = { (x, s) in
			self.tryGet(from: s).bimap({ (x, $0) }, { (x, $0) })
		}
		
		return P (
			tryGet: tryGet,
			reverseGet: { (x, at) in (x, self.reverseGet(from: at)) }
		)
	}
	
	public func left <T, P: PrismGenerator where
		P.Source	== Either<Source, T>,
		P.AltSource == Either<AltSource, T>,
		P.Target	== Either<Target, T>,
		P.AltTarget == Either<AltTarget, T>> () -> P
	{
		let tryGet: (Either<Source, T>) -> Either<Either<AltSource, T>, Either<Target, T>> = { e in
			e.either(
				ifLeft: { self.tryGet(from: $0).bimap(Either.left, Either.left) },
				ifRight: Either.right • Either.right
			)
		}
		
		return P (
			tryGet: tryGet,
			reverseGet: { $0.map(self.reverseGet) }
		)
	}
	
	public func right <T, P: PrismGenerator where
		P.Source	== Either<T, Source>,
		P.AltSource == Either<T, AltSource>,
		P.Target	== Either<T, Target>,
		P.AltTarget == Either<T, AltTarget>> () -> P
	{
		let tryGet: (Either<T, Source>) -> Either<Either<T, AltSource>, Either<T, Target>> = { e in
			e.either(
				ifLeft: Either.left • Either.left,
				ifRight: { self.tryGet(from: $0).bimap(Either.right, Either.right) })
		}
		
		return P(
			tryGet: tryGet,
			reverseGet: { $0.map(self.reverseGet) }
		)
	}
}

public extension PrismGenerator {
	public var asLSetter: LSetter<Source, AltSource, Target, AltTarget> {
		return LSetter(modify: modify)
	}
	
	public var asLPrism: LPrism<Source, AltSource, Target, AltTarget> {
		return LPrism(tryGet: tryGet, reverseGet: reverseGet)
	}
}

public extension PrismGenerator where Source == AltSource, Target == AltTarget {
	public var asSetter: Setter<Source, Target> {
		return Setter(modify: modify)
	}
	
	public var asPrism: Prism<Source, Target> {
		return Prism(tryGet: tryGet, reverseGet: reverseGet)
	}
}

public extension PrismGenerator where Source == AltSource {
	public static func prism(tryGet: (Source) -> Target?, reverseGet: (AltTarget) -> Source) -> LPrism<Source, Source, Target, AltTarget> {
		let g: (Source) -> Either<Source, Target> = { source in
			if let it = tryGet(source) {
				return .right(it)
			}else {
				return .left(source)
			}
		}
		return LPrism(tryGet: g, reverseGet: reverseGet)
	}
	
	public static func prism(tryGet: (Source) -> Target?, reverseGet: (Target) -> Source) -> Prism<Source, Target> {
		let g: (Source) -> Either<Source, Target> = { source in
			if let it = tryGet(source) {
				return .right(it)
			}else {
				return .left(source)
			}
		}
		return Prism(tryGet: g, reverseGet: reverseGet)
	}
}

// MARK: - LPrism

public struct LPrism<S, T, A, B> {
	private let _tryGet: (S) -> Either<T, A>
	private let _reverseGet: (B) -> T
	
	public init(tryGet: (S) -> Either<T, A>, reverseGet: (B) -> T) {
		_tryGet = tryGet
		_reverseGet = reverseGet
	}
}

extension LPrism: PrismGenerator {
	public typealias Source = S
	public typealias AltSource = T
	public typealias Target = A
	public typealias AltTarget = B
	
	public func tryGet(from: S) -> Either<T, A> {
		return _tryGet(from)
	}
	
	public func reverseGet(from: B) -> T {
		return _reverseGet(from)
	}
}

// MARK: - Prism

public struct Prism<S, A> {
	private let _tryGet: (S) -> Either<S, A>
	private let _reverseGet: (A) -> S
	
	public init(tryGet: (S) -> Either<S, A>, reverseGet: (A) -> S) {
		_tryGet = tryGet
		_reverseGet = reverseGet
	}
}

extension Prism: PrismGenerator {
	public typealias Source = S
	public typealias AltSource = S
	public typealias Target = A
	public typealias AltTarget = A
	
	public func tryGet(from: S) -> Either<S, A> {
		return _tryGet(from)
	}
	
	public func reverseGet(from: A) -> S {
		return _reverseGet(from)
	}
}


