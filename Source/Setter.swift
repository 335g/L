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

// MARK: - Setter

/// A `Setter` describes a way of applying a transformation to a subpart of a structure.
///
/// - parameter S: The structure
/// - parameter A: The subpart of a structure
public typealias Setter<S, A> = LSetter<S, S, A, A>

// MARK: - SetterProtocol

public protocol SetterProtocol: OpticsProtocol {
	func modify(_ x: Source, as f: @escaping (Target) -> AltTarget) -> AltSource
}

extension SetterProtocol {
	public func set(_ y: AltTarget, to x: Source) -> AltSource {
		return modify(x, as: { _ in y })
	}
}

extension LSetter: SetterProtocol {
    public typealias Source = S
    public typealias Target = A
    public typealias AltSource = T
    public typealias AltTarget = B
    
    public func modify(_ x: S, as f: @escaping (A) -> B) -> T {
        return _modify(x, f)
    }
}

extension SetterProtocol {
    public func choice<S, A, B>(_ other: S) -> LSetter<Either<Source, A>, Either<AltSource, B>, Target, AltTarget> where
        S: SetterProtocol,
        S.Source == A,
        S.AltSource == B,
        S.Target == Target,
        S.AltTarget == AltTarget
    {
        let modify: (Either<Source, A>, @escaping (Target) -> AltTarget) -> Either<AltSource, B> = { e, f in
            e.either(
                ifLeft: { Either.left(self.modify($0, as: f)) },
                ifRight: { Either.right(other.modify($0, as: f)) }
            )
        }
        
        return LSetter<Either<Source, A>, Either<AltSource, B>, Target, AltTarget>(modify: modify)
    }
}

extension SetterProtocol {
    public var setter: LSetter<Source, AltSource, Target, AltTarget> {
        return LSetter(modify: modify)
    }
}
