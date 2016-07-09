//  Copyright © 2016 Yoshiki Kudo. All rights reserved.

import Bass

// MARK: - Getter

public extension Getter {
	public func compose<C>(_ other: Getter<A, C>) -> Getter<S, C> {
		return Getter<S, C>(get: other.get • self.get)
	}
	
	public func compose<B, C, D>(_ other: LLens<A, B, C, D>) -> Getter<S, C> {
		return compose(other.asGetter)
	}
	
	public func compose<C>(_ other: Lens<A, C>) -> Getter<S, C> {
		return compose(other.asGetter)
	}
	
	public func compose<B, C, D>(_ other: LIso<A, B, C, D>) -> Getter<S, C> {
		return compose(other.asGetter)
	}
	
	public func compose<C>(_ other: Iso<A, C>) -> Getter<S, C> {
		return compose(other.asGetter)
	}
}

// MARK: - LSetter

public extension LSetter {
	public func compose<C, D>(_ other: LSetter<A, B, C, D>) -> LSetter<S, T, C, D> {
		let compositionModify: (S, (C) -> D) -> T = { s, f in
			self.modify(s){ a in
				other.modify(a, as: f)
			}
		}
		
		return LSetter<S, T, C, D>(modify: compositionModify)
	}
	
	public func compose<C, D>(_ other: LLens<A, B, C, D>) -> LSetter<S, T, C, D> {
		return compose(other.asLSetter)
	}
	
	public func compose<C, D>(_ other: LPrism<A, B, C, D>) -> LSetter<S, T, C, D> {
		return compose(other.asLSetter)
	}
	
	public func compose<C, D>(_ other: LIso<A, B, C, D>) -> LSetter<S, T, C, D> {
		return compose(other.asLSetter)
	}
}

// MARK: - Setter

public extension Setter {
	public func compose<C>(_ other: Setter<A, C>) -> Setter<S, C> {
		let compositionModify: (S, (C) -> C) -> S = { s, f in
			self.modify(s){ a in
				other.modify(a, as: f)
			}
		}
		
		return Setter<S, C>(modify: compositionModify)
	}
	
	public func compose<C>(_ other: LLens<A, A, C, C>) -> Setter<S, C> {
		return compose(other.asSetter)
	}
	
	public func compose<C>(_ other: Lens<A, C>) -> Setter<S, C> {
		return compose(other.asSetter)
	}
	
	public func compose<C>(_ other: LPrism<A, A, C, C>) -> Setter<S, C> {
		return compose(other.asSetter)
	}
	
	public func compose<C>(_ other: Prism<A, C>) -> Setter<S, C> {
		return compose(other.asSetter)
	}
	
	public func compose<C>(_ other: LIso<A, A, C, C>) -> Setter<S, C> {
		return compose(other.asSetter)
	}
	
	public func compose<C>(_ other: Iso<A, C>) -> Setter<S, C> {
		return compose(other.asSetter)
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
	
	public func compose<C, D>(_ other: LIso<A, B, C, D>) -> LPrism<S, T, C, D> {
		return compose(other.asLPrism)
	}
	
	public func compose<C, D>(_ other: LSetter<A, B, C, D>) -> LSetter<S, T, C, D> {
		return asLSetter.compose(other)
	}
}

// MARK: - Prism

public extension Prism {
	public func compose<C>(_ other: Prism<A, C>) -> Prism<S, C> {
		let compositionTryGet: (S) -> Either<S, C> = { s in
			self.tryGet(from: s)
				.flatMap{ a in
					other.tryGet(from: a).bimap({ a2 in self.set(a2, to: s) }, id)
				}
		}
		
		return Prism<S, C>(
			tryGet: compositionTryGet,
			reverseGet: self.reverseGet • other.reverseGet
		)
	}
	
	public func compose<C>(_ other: LIso<A, A, C, C>) -> Prism<S, C> {
		return compose(other.asPrism)
	}
	
	public func compose<C>(_ other: Iso<A, C>) -> Prism<S, C> {
		return compose(other.asPrism)
	}
	
	public func compose<C>(_ other: LSetter<A, A, C, C>) -> LSetter<S, S, C, C> {
		return asLSetter.compose(other)
	}
	
	public func compose<C>(_ other: Setter<A, C>) -> Setter<S, C> {
		return asSetter.compose(other)
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
	
	public func compose<C, D>(_ other: LIso<A, B, C, D>) -> LLens<S, T, C, D> {
		return compose(other.asLLens)
	}
	
	public func compose<C, D>(_ other: LSetter<A, B, C, D>) -> LSetter<S, T, C, D> {
		return asLSetter.compose(other)
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
	
	public func compose<C>(_ other: LIso<A, A, C, C>) -> Lens<S, C> {
		return compose(other.asLens)
	}
	
	public func compose<C>(_ other: Iso<A, C>) -> Lens<S, C> {
		return compose(other.asLens)
	}
	
	public func compose<C>(_ other: LSetter<A, A, C, C>) -> LSetter<S, S, C, C> {
		return asLSetter.compose(other)
	}
	
	public func compose<C>(_ other: Setter<A, C>) -> Setter<S, C> {
		return asSetter.compose(other)
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
	
	public func compose<C, D>(_ other: LSetter<A, B, C, D>) -> LSetter<S, T, C, D> {
		return asLSetter.compose(other)
	}
	
	public func compose<C, D>(_ other: LLens<A, B, C, D>) -> LLens<S, T, C, D> {
		return asLLens.compose(other)
	}
	
	public func compose<C, D>(_ other: LPrism<A, B, C, D>) -> LPrism<S, T, C, D> {
		return asLPrism.compose(other)
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
	
	public func compose<C>(_ other: LSetter<A, A, C, C>) -> LSetter<S, S, C, C> {
		return asLSetter.compose(other)
	}
	
	public func compose<C>(_ other: Setter<A, C>) -> Setter<S, C> {
		return asSetter.compose(other)
	}
	
	public func compose<C>(_ other: LLens<A, A, C, C>) -> LLens<S, S, C, C> {
		return asLLens.compose(other)
	}
	
	public func compose<C>(_ other: Lens<A, C>) -> Lens<S, C> {
		return asLens.compose(other)
	}
	
	public func compose<C>(_ other: LPrism<A, A, C, C>) -> LPrism<S, S, C, C> {
		return asLPrism.compose(other)
	}
	
	public func compose<C>(_ other: Prism<A, C>) -> Prism<S, C> {
		return asPrism.compose(other)
	}
}
