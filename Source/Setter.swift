//  Copyright © 2016 Yoshiki Kudo. All rights reserved.

import Bass

// MARK: - SetterProtocol

public protocol SetterProtocol: OpticsType {
	func modify(_ x: Source, as f: (Target) -> AltTarget) -> AltSource
}

public extension SetterProtocol {
	public func set(_ y: AltTarget, to x: Source) -> AltSource {
		return modify(x, as: { _ in y })
	}
}

// MARK: - SetterGenerator

public protocol SetterGenerator: SetterProtocol {
	init(modify: (Source, (Target) -> AltTarget) -> AltSource)
}

public extension SetterGenerator {
	public func choice<S, T, S1: SetterGenerator, S2: SetterGenerator where S1.Source == S, S1.AltSource == T, S1.Target == Target, S1.AltTarget == AltTarget, S2.Source == Either<Source, S>, S2.AltSource == Either<AltSource, T>, S2.Target == Target, S2.AltTarget == AltTarget>(_ other: S1) -> S2 {
		
		let modify: (Either<Source, S>, (Target) -> AltTarget) -> Either<AltSource, T> = { e, f in
			e.either(
				ifLeft: { Either.left(self.modify($0, as: f)) },
				ifRight: { Either.right(other.modify($0, as: f)) }
			)
		}
		
		return S2(modify: modify)
	}
}

// MARK: - LSetter

public struct LSetter<S, T, A, B> {
	private let _modify: (S, (A) -> B) -> T
	
	public init(modify: (S, (A) -> B) -> T) {
		_modify = modify
	}
}

extension LSetter: SetterGenerator {
	public typealias Source = S
	public typealias AltSource = T
	public typealias Target = A
	public typealias AltTarget = B
	
	public func modify(_ x: S, as f: (A) -> B) -> T {
		return _modify(x, f)
	}
}

// MARK: - Setter

public struct Setter<S, A> {
	private let _modify: (S, (A) -> A) -> S
	
	public init(modify: (S, (A) -> A) -> S) {
		_modify = modify
	}
}

extension Setter: SetterGenerator {
	public typealias Source = S
	public typealias AltSource = S
	public typealias Target = A
	public typealias AltTarget = A
	
	public func modify(_ x: S, as f: (A) -> A) -> S {
		return _modify(x, f)
	}
}
