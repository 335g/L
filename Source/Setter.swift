//  Copyright © 2016 Yoshiki Kudo. All rights reserved.

import Either

// MARK: - LSetter

/// A `LSetter` describes a way of applying a transformation to a subpart of a structure.
///
/// - parameter S: The structure to be modified
/// - parameter T: The modified form of the structure
/// - parameter A: The existing subpart to be modified
/// - parameter B: The result of modifying the subpart
public struct LSetter<S, T, A, B> {
	fileprivate let _modify: (S, @escaping (A) -> B) -> T
	
	public init(modify: @escaping (S, @escaping (A) -> B) -> T) {
		_modify = modify
	}
}

extension LSetter: SetterGenerator {
	public typealias Source = S
	public typealias AltSource = T
	public typealias Target = A
	public typealias AltTarget = B
	
	public func modify(_ x: S, as f: @escaping (A) -> B) -> T {
		return _modify(x, f)
	}
}

// MARK: - Setter

/// A `Setter` describes a way of applying a transformation to a subpart of a structure.
///
/// - parameter S: The structure
/// - parameter A: The subpart of a structure
public struct Setter<S, A> {
	fileprivate let _modify: (S, @escaping (A) -> A) -> S
	
	public init(modify: @escaping (S, @escaping (A) -> A) -> S) {
		_modify = modify
	}
}

extension Setter: SetterGenerator {
	public typealias Source = S
	public typealias AltSource = S
	public typealias Target = A
	public typealias AltTarget = A
	
	public func modify(_ x: S, as f: @escaping (A) -> A) -> S {
		return _modify(x, f)
	}
}



// MARK: - SetterProtocol

public protocol SetterProtocol: OpticsProtocol {
	func modify(_ x: Source, as f: @escaping (Target) -> AltTarget) -> AltSource
}

public extension SetterProtocol {
	public func set(_ y: AltTarget, to x: Source) -> AltSource {
		return modify(x, as: { _ in y })
	}
}

// MARK: - SetterGenerator

public protocol SetterGenerator: SetterProtocol {
	init(modify: @escaping (Source, @escaping (Target) -> AltTarget) -> AltSource)
}

public extension SetterGenerator {
	public func choice <S, T, S1: SetterGenerator, S2: SetterGenerator> (_ other: S1) -> S2 where
		S1.Source		== S,
		S1.AltSource	== T,
		S1.Target		== Target,
		S1.AltTarget	== AltTarget,
		S2.Source		== Either<Source, S>,
		S2.AltSource	== Either<AltSource, T>,
		S2.Target		== Target,
		S2.AltTarget	== AltTarget
	{
		let modify: (Either<Source, S>, @escaping (Target) -> AltTarget) -> Either<AltSource, T> = { e, f in
			e.either(
				ifLeft: { Either.left(self.modify($0, as: f)) },
				ifRight: { Either.right(other.modify($0, as: f)) }
			)
		}
		
		return S2(modify: modify)
	}
}

public extension SetterGenerator {
	public var asLSetter: LSetter<Source, AltSource, Target, AltTarget> {
		return LSetter(modify: modify)
	}
}

public extension SetterGenerator where Source == AltSource, Target == AltTarget {
	public var asSetter: Setter<Source, Target> {
		return Setter(modify: modify)
	}
}

