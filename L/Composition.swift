//  Copyright © 2016 Yoshiki Kudo. All rights reserved.

import Bass

// MARK: - Getter

public extension Getter {
	public func compose<C>(_ other: Getter<A, C>) -> Getter<S, C> {
		return Getter<S, C>(get: other.get • self.get)
	}
}

// MARK: - LPrism

public extension LPrism {
	public func compose<C, D>(_ other: LPrism<A, B, C, D>) -> LPrism<S, T, C, D> {
		let tryGet: (S) -> Either<T, C> = { s in
			self.tryGet(from: s)
				.flatMap{ a in
					other.tryGet(from: a).bimap({ b in self.set(b, to: s) }, id)
			}
		}
		
		return LPrism<S, T, C, D>(
			tryGet: tryGet,
			reverseGet: self.reverseGet • other.reverseGet
		)
	}
}

// MARK: - Prism

public extension Prism {
	public func compose<C>(_ other: Prism<A, C>) -> Prism<S, C> {
		let tryGet: (S) -> Either<S, C> = { s in
			self.tryGet(from: s)
				.flatMap{ a in
					other.tryGet(from: a).bimap({ a2 in self.set(a2, to: s) }, id)
				}
		}
		
		return Prism<S, C>(
			tryGet: tryGet,
			reverseGet: self.reverseGet • other.reverseGet
		)
	}
}

// MARK: - LLens

public extension LLens {
	public func compose<C, D>(_ other: LLens<A, B, C, D>) -> LLens<S, T, C, D> {
		return LLens<S, T, C, D>(
			get: other.get • self.get,
			set: { d, s in
				self.modify(s){ other.set(d, to: $0) }
			}
		)
	}
}

// MARK: - Lens

public extension Lens {
	public func compose<C>(_ other: Lens<A, C>) -> Lens<S, C> {
		return Lens<S, C>(
			get: other.get • self.get,
			set: { c, s in
				self.modify(s){ other.set(c, to: $0) }
			}
		)
	}
}

// MARK: - LIso

public extension LIso {
	public func compose<C, D>(_ other: LIso<A, B, C, D>) -> LIso<S, T, C, D> {
		return LIso<S, T, C, D>(
			get: other.get • self.get,
			reverseGet: self.reverseGet • other.reverseGet
		)
	}
}

// MARK: - Iso

public extension Iso {
	public func compose<C>(_ other: Iso<A, C>) -> Iso<S, C> {
		return Iso<S, C>(
			get: other.get • self.get,
			reverseGet: self.reverseGet • other.reverseGet
		)
	}
}
