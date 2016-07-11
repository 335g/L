//  Copyright © 2016 Yoshiki Kudo. All rights reserved.

// MARK: - SetterType

public protocol SetterType: OpticsType {
	func modify(_ x: Source, as f: (Target) -> AltTarget) -> AltSource
	init(modify: (Source, (Target) -> AltTarget) -> AltSource)
}

public extension SetterType {
	public func set(_ y: AltTarget, to x: Source) -> AltSource {
		return modify(x, as: { _ in y })
	}
}

// MARK: - LSetter

public struct LSetter<S, T, A, B> {
	private let _modify: (S, (A) -> B) -> T
	
	public init(modify: (S, (A) -> B) -> T) {
		_modify = modify
	}
}

extension LSetter: SetterType {
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

extension Setter: SetterType {
	public typealias Source = S
	public typealias AltSource = S
	public typealias Target = A
	public typealias AltTarget = A
	
	public func modify(_ x: S, as f: (A) -> A) -> S {
		return _modify(x, f)
	}
}
