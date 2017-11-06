//  Copyright © 2016 Yoshiki Kudo. All rights reserved.

import Prelude
import Either

// MARK: - Getter

extension Getter {
	public func compose<C>(_ other: Getter<A, C>) -> Getter<S, C> {
		return Getter<S, C>(get: other.get <<< self.get)
	}
	
	public func compose<B, C, D>(_ other: LLens<A, B, C, D>) -> Getter<S, C> {
		return compose(other.getter)
	}
	
	public func compose<C>(_ other: Lens<A, C>) -> Getter<S, C> {
		return compose(other.getter)
	}
	
	public func compose<B, C, D>(_ other: LIso<A, B, C, D>) -> Getter<S, C> {
		return compose(other.getter)
	}
	
	public func compose<C>(_ other: Iso<A, C>) -> Getter<S, C> {
		return compose(other.getter)
	}
    
    // operator
    
    public static func >>> <T>(lhs: Getter, rhs: Getter<Target, T>) -> Getter<Source, T> {
        return lhs.compose(rhs)
    }
    
    public static func >>> <T, U, V>(lhs: Getter, rhs: LLens<Target, T, U, V>) -> Getter<Source, U> {
        return lhs.compose(rhs)
    }
    
    public static func >>> <T>(lhs: Getter, rhs: Lens<Target, T>) -> Getter<Source, T> {
        return lhs.compose(rhs)
    }
    
    public static func >>> <T, U, V>(lhs: Getter, rhs: LIso<Target, T, U, V>) -> Getter<Source, U> {
        return lhs.compose(rhs)
    }
    
    public static func >>> <T>(lhs: Getter, rhs: Iso<Target, T>) -> Getter<Source, T> {
        return lhs.compose(rhs)
    }
}

// MARK: - LSetter

extension LSetter {
	public func compose<C, D>(_ other: LSetter<A, B, C, D>) -> LSetter<S, T, C, D> {
		let compositionModify: (S, @escaping (C) -> D) -> T = { s, f in
			self.modify(s){ a in
				other.modify(a, as: f)
			}
		}
		
		return LSetter<S, T, C, D>(modify: compositionModify)
	}
	
	public func compose<C, D>(_ other: LLens<A, B, C, D>) -> LSetter<S, T, C, D> {
		return compose(other.setter)
	}
	
	public func compose<C, D>(_ other: LPrism<A, B, C, D>) -> LSetter<S, T, C, D> {
		return compose(other.setter)
	}
	
	public func compose<C, D>(_ other: LIso<A, B, C, D>) -> LSetter<S, T, C, D> {
		return compose(other.setter)
	}
    
    // operator
    
    public static func >>> <T, U>(lhs: LSetter, rhs: LSetter<Target, AltTarget, T, U>) -> LSetter<Source, AltSource, T, U> {
        return lhs.compose(rhs)
    }
    
    public static func >>> <T, U>(lhs: LSetter, rhs: LLens<Target, AltTarget, T, U>) -> LSetter<Source, AltSource, T, U> {
        return lhs.compose(rhs)
    }
    
    public static func >>> <T, U>(lhs: LSetter, rhs: LPrism<Target, AltTarget, T, U>) -> LSetter<Source, AltSource, T, U> {
        return lhs.compose(rhs)
    }
    
    public static func >>> <T, U>(lhs: LSetter, rhs: LIso<Target, AltTarget, T, U>) -> LSetter<Source, AltSource, T, U> {
        return lhs.compose(rhs)
    }
}

// MARK: - LPrism

public extension LPrism {
	public func compose<C, D>(_ other: LPrism<A, B, C, D>) -> LPrism<S, T, C, D> {
		let compositionTryGet: (S) -> Either<T, C> = { s in
			self.tryGet(from: s)
				.flatMap{ a in
					other.tryGet(from: a).mapLeft{ self.set($0, to: s) }
				}
		}
		
		return LPrism<S, T, C, D>(
			tryGet: compositionTryGet,
			reverseGet: self.reverseGet <<< other.reverseGet
		)
	}
	
	public func compose<C, D>(_ other: LIso<A, B, C, D>) -> LPrism<S, T, C, D> {
		return compose(other.prism)
	}
	
	public func compose<C, D>(_ other: LSetter<A, B, C, D>) -> LSetter<S, T, C, D> {
		return setter.compose(other)
	}
    
    // operator
    
    public static func >>> <T, U>(lhs: LPrism, rhs: LPrism<Target, AltTarget, T, U>) -> LPrism<Source, AltSource, T, U> {
        return lhs.compose(rhs)
    }
    
    public static func >>> <T, U>(lhs: LPrism, rhs: LIso<Target, AltTarget, T, U>) -> LPrism<Source, AltSource, T, U> {
        return lhs.compose(rhs)
    }
    
    public static func >>> <T, U>(lhs: LPrism, rhs: LSetter<Target, AltTarget, T, U>) -> LSetter<Source, AltSource, T, U> {
        return lhs.compose(rhs)
    }
}

// MARK: - LLens

public extension LLens {
	public func compose<C, D>(_ other: LLens<A, B, C, D>) -> LLens<S, T, C, D> {
		return LLens<S, T, C, D>(
			get: other.get <<< self.get,
			set: { d, s in
				self.modify(s){ other.set(d, to: $0) }
			}
		)
	}
	
	public func compose<C, D>(_ other: LIso<A, B, C, D>) -> LLens<S, T, C, D> {
		return compose(other.lens)
	}
	
	public func compose<C, D>(_ other: LSetter<A, B, C, D>) -> LSetter<S, T, C, D> {
		return setter.compose(other)
	}
    
    // operator
    
    public static func >>> <T, U>(lhs: LLens, rhs: LLens<Target, AltTarget, T, U>) -> LLens<Source, AltSource, T, U> {
        return lhs.compose(rhs)
    }
    
    public static func >>> <T, U>(lhs: LLens, rhs: LIso<Target, AltTarget, T, U>) -> LLens<Source, AltSource, T, U> {
        return lhs.compose(rhs)
    }
    
    public static func >>> <T, U>(lhs: LLens, rhs: LSetter<Target, AltTarget, T, U>) -> LSetter<Source, AltSource, T, U> {
        return lhs.compose(rhs)
    }
}

// MARK: - LIso

public extension LIso {
	public func compose<C, D>(_ other: LIso<A, B, C, D>) -> LIso<S, T, C, D> {
		return LIso<S, T, C, D>(
			get: other.get <<< self.get,
			reverseGet: self.reverseGet <<< other.reverseGet
		)
	}
	
	public func compose<C, D>(_ other: LSetter<A, B, C, D>) -> LSetter<S, T, C, D> {
		return setter.compose(other)
	}
	
	public func compose<C, D>(_ other: LLens<A, B, C, D>) -> LLens<S, T, C, D> {
		return lens.compose(other)
	}
	
	public func compose<C, D>(_ other: LPrism<A, B, C, D>) -> LPrism<S, T, C, D> {
		return prism.compose(other)
	}
    
    // operator
    
    public static func >>> <T, U>(lhs: LIso, rhs: LIso<Target, AltTarget, T, U>) -> LIso<Source, AltSource, T, U> {
        return lhs.compose(rhs)
    }
    
    public static func >>> <T, U>(lhs: LIso, rhs: LSetter<Target, AltTarget, T, U>) -> LSetter<Source, AltSource, T, U> {
        return lhs.compose(rhs)
    }
    
    public static func >>> <T, U>(lhs: LIso, rhs: LLens<Target, AltTarget, T, U>) -> LLens<Source, AltSource, T, U> {
        return lhs.compose(rhs)
    }
    
    public static func >>> <T, U>(lhs: LIso, rhs: LPrism<Target, AltTarget, T, U>) -> LPrism<Source, AltSource, T, U> {
        return lhs.compose(rhs)
    }
}
