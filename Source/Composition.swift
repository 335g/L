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

public func >>> <S, A, C>(lhs: Getter<S, A>, rhs: Getter<A, C>) -> Getter<S, C> {
	return lhs.compose(rhs)
}

public func >>> <S, A, B, C, D>(lhs: Getter<S, A>, rhs: LLens<A, B, C, D>) -> Getter<S, C> {
	return lhs.compose(rhs)
}

public func >>> <S, A, C>(lhs: Getter<S, A>, rhs: Lens<A, C>) -> Getter<S, C> {
	return lhs.compose(rhs)
}

public func >>> <S, A, B, C, D>(lhs: Getter<S, A>, rhs: LIso<A, B, C, D>) -> Getter<S, C> {
	return lhs.compose(rhs)
}

public func >>> <S, A, C>(lhs: Getter<S, A>, rhs: Iso<A, C>) -> Getter<S, C> {
	return lhs.compose(rhs)
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

public func >>> <S, T, A, B, C, D>(lhs: LSetter<S, T, A, B>, rhs: LSetter<A, B, C, D>) -> LSetter<S, T, C, D> {
	return lhs.compose(rhs)
}

public func >>> <S, T, A, B, C, D>(lhs: LSetter<S, T, A, B>, rhs: LLens<A, B, C, D>) -> LSetter<S, T, C, D> {
	return lhs.compose(rhs)
}

public func >>> <S, T, A, B, C, D>(lhs: LSetter<S, T, A, B>, rhs: LPrism<A, B, C, D>) -> LSetter<S, T, C, D> {
	return lhs.compose(rhs)
}

public func >>> <S, T, A, B, C, D>(lhs: LSetter<S, T, A, B>, rhs: LIso<A, B, C, D>) -> LSetter<S, T, C, D> {
	return lhs.compose(rhs)
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
	
	public func compose<C>(_ other: LSetter<A, A, C, C>) -> Setter<S, C> {
		return compose(other.asSetter)
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

public func >>> <S, A, C>(lhs: Setter<S, A>, rhs: Setter<A, C>) -> Setter<S, C> {
	return lhs.compose(rhs)
}

public func >>> <S, A, C>(lhs: Setter<S, A>, rhs: LSetter<A, A, C, C>) -> Setter<S, C> {
	return lhs.compose(rhs)
}

public func >>> <S, A, C>(lhs: Setter<S, A>, rhs: LLens<A, A, C, C>) -> Setter<S, C> {
	return lhs.compose(rhs)
}

public func >>> <S, A, C>(lhs: Setter<S, A>, rhs: Lens<A, C>) -> Setter<S, C> {
	return lhs.compose(rhs)
}

public func >>> <S, A, C>(lhs: Setter<S, A>, rhs: LPrism<A, A, C, C>) -> Setter<S, C> {
	return lhs.compose(rhs)
}

public func >>> <S, A, C>(lhs: Setter<S, A>, rhs: Prism<A, C>) -> Setter<S, C> {
	return lhs.compose(rhs)
}

public func >>> <S, A, C>(lhs: Setter<S, A>, rhs: LIso<A, A, C, C>) -> Setter<S, C> {
	return lhs.compose(rhs)
}

public func >>> <S, A, C>(lhs: Setter<S, A>, rhs: Iso<A, C>) -> Setter<S, C> {
	return lhs.compose(rhs)
}

// MARK: - LPrism

public extension LPrism {
	public func compose<C, D>(_ other: LPrism<A, B, C, D>) -> LPrism<S, T, C, D> {
		let compositionTryGet: (S) -> Either<T, C> = { s in
			self.tryGet(from: s)
				.flatMap{ a in
					other.tryGet(from: a).map{ self.set($0, to: s) }
				}
		}
		
		return LPrism<S, T, C, D>(
			tryGet: compositionTryGet,
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

public func >>> <S, T, A, B, C, D>(lhs: LPrism<S, T, A, B>, rhs: LPrism<A, B, C, D>) -> LPrism<S, T, C, D> {
	return lhs.compose(rhs)
}

public func >>> <S, T, A, B, C, D>(lhs: LPrism<S, T, A, B>, rhs: LIso<A, B, C, D>) -> LPrism<S, T, C, D> {
	return lhs.compose(rhs)
}

public func >>> <S, T, A, B, C, D>(lhs: LPrism<S, T, A, B>, rhs: LSetter<A, B, C, D>) -> LSetter<S, T, C, D> {
	return lhs.compose(rhs)
}

// MARK: - Prism

public extension Prism {
	public func compose<C>(_ other: Prism<A, C>) -> Prism<S, C> {
		let compositionTryGet: (S) -> Either<S, C> = { s in
			self.tryGet(from: s)
				.flatMap{ a in
					other.tryGet(from: a).map{ self.set($0, to: s) }
				}
		}
		
		return Prism<S, C>(
			tryGet: compositionTryGet,
			reverseGet: self.reverseGet • other.reverseGet
		)
	}
	
	public func compose<C>(_ other: LPrism<A, A, C, C>) -> Prism<S, C> {
		return compose(other.asPrism)
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

public func >>> <S, A, C>(lhs: Prism<S, A>, rhs: Prism<A, C>) -> Prism<S, C> {
	return lhs.compose(rhs)
}

public func >>> <S, A, C>(lhs: Prism<S, A>, rhs: LPrism<A, A, C, C>) -> Prism<S, C> {
	return lhs.compose(rhs)
}

public func >>> <S, A, C>(lhs: Prism<S, A>, rhs: LIso<A, A, C, C>) -> Prism<S, C> {
	return lhs.compose(rhs)
}

public func >>> <S, A, C>(lhs: Prism<S, A>, rhs: Iso<A, C>) -> Prism<S, C> {
	return lhs.compose(rhs)
}

public func >>> <S, A, C>(lhs: Prism<S, A>, rhs: LSetter<A, A, C, C>) -> LSetter<S, S, C, C> {
	return lhs.compose(rhs)
}

public func >>> <S, A, C>(lhs: Prism<S, A>, rhs: Setter<A, C>) -> Setter<S, C> {
	return lhs.compose(rhs)
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

public func >>> <S, T, A, B, C, D>(lhs: LLens<S, T, A, B>, rhs: LLens<A, B, C, D>) -> LLens<S, T, C, D> {
	return lhs.compose(rhs)
}

public func >>> <S, T, A, B, C, D>(lhs: LLens<S, T, A, B>, rhs: LIso<A, B, C, D>) -> LLens<S, T, C, D> {
	return lhs.compose(rhs)
}

public func >>> <S, T, A, B, C, D>(lhs: LLens<S, T, A, B>, rhs: LSetter<A, B, C, D>) -> LSetter<S, T, C, D> {
	return lhs.compose(rhs)
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
	
	public func compose<C>(_ other: LLens<A, A, C, C>) -> Lens<S, C> {
		return compose(other.asLens)
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

public func >>> <S, A, C>(lhs: Lens<S, A>, rhs: Lens<A, C>) -> Lens<S, C> {
	return lhs.compose(rhs)
}

public func >>> <S, A, C>(lhs: Lens<S, A>, rhs: LLens<A, A, C, C>) -> Lens<S, C> {
	return lhs.compose(rhs)
}

public func >>> <S, A, C>(lhs: Lens<S, A>, rhs: LIso<A, A, C, C>) -> Lens<S, C> {
	return lhs.compose(rhs)
}

public func >>> <S, A, C>(lhs: Lens<S, A>, rhs: Iso<A, C>) -> Lens<S, C> {
	return lhs.compose(rhs)
}

public func >>> <S, A, C>(lhs: Lens<S, A>, rhs: LSetter<A, A, C, C>) -> LSetter<S, S, C, C> {
	return lhs.compose(rhs)
}

public func >>> <S, A, C>(lhs: Lens<S, A>, rhs: Setter<A, C>) -> Setter<S, C> {
	return lhs.compose(rhs)
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

public func >>> <S, T, A, B, C, D>(lhs: LIso<S, T, A, B>, rhs: LIso<A, B, C, D>) -> LIso<S, T, C, D> {
	return lhs.compose(rhs)
}

public func >>> <S, T, A, B, C, D>(lhs: LIso<S, T, A, B>, rhs: LSetter<A, B, C, D>) -> LSetter<S, T, C, D> {
	return lhs.compose(rhs)
}

public func >>> <S, T, A, B, C, D>(lhs: LIso<S, T, A, B>, rhs: LLens<A, B, C, D>) -> LLens<S, T, C, D> {
	return lhs.compose(rhs)
}

public func >>> <S, T, A, B, C, D>(lhs: LIso<S, T, A, B>, rhs: LPrism<A, B, C, D>) -> LPrism<S, T, C, D> {
	return lhs.compose(rhs)
}

// MARK: - Iso

public extension Iso {
	public func compose<C>(_ other: Iso<A, C>) -> Iso<S, C> {
		return Iso<S, C>(
			get: other.get • self.get,
			reverseGet: self.reverseGet • other.reverseGet
		)
	}
	
	public func compose<C>(_ other: LIso<A, A, C, C>) -> Iso<S, C> {
		return compose(other.asIso)
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

public func >>> <S, A, C>(lhs: Iso<S, A>, rhs: Iso<A, C>) -> Iso<S, C> {
	return lhs.compose(rhs)
}

public func >>> <S, A, C>(lhs: Iso<S, A>, rhs: LIso<A, A, C, C>) -> Iso<S, C> {
	return lhs.compose(rhs)
}

public func >>> <S, A, C>(lhs: Iso<S, A>, rhs: LSetter<A, A, C, C>) -> LSetter<S, S, C, C> {
	return lhs.compose(rhs)
}

public func >>> <S, A, C>(lhs: Iso<S, A>, rhs: Setter<A, C>) -> Setter<S, C> {
	return lhs.compose(rhs)
}

public func >>> <S, A, C>(lhs: Iso<S, A>, rhs: LLens<A, A, C, C>) -> LLens<S, S, C, C> {
	return lhs.compose(rhs)
}

public func >>> <S, A, C>(lhs: Iso<S, A>, rhs: Lens<A, C>) -> Lens<S, C> {
	return lhs.compose(rhs)
}

public func >>> <S, A, C>(lhs: Iso<S, A>, rhs: LPrism<A, A, C, C>) -> LPrism<S, S, C, C> {
	return lhs.compose(rhs)
}

public func >>> <S, A, C>(lhs: Iso<S, A>, rhs: Prism<A, C>) -> Prism<S, C> {
	return lhs.compose(rhs)
}
