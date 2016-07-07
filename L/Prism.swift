//  Copyright © 2016 Yoshiki Kudo. All rights reserved.

import Bass

// MARK: - PrismType

public protocol PrismType: SetterType {
	func tryGet(from: Source) -> Either<AltSource, Target>
	func reverseGet(from: AltTarget) -> AltSource
}

public extension PrismType {
	public func modify(_ x: Source, as f: (Target) -> AltTarget) -> AltSource {
		return tryGet(from: x).either(
			ifLeft: id,
			ifRight: reverseGet • f
		)
	}
}

public extension PrismType where Source == AltSource {
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

extension LPrism: PrismType {
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

extension Prism: PrismType {
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


