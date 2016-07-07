//  Copyright © 2016 Yoshiki Kudo. All rights reserved.

public protocol SimpleOpticsType {
	associatedtype Source
	associatedtype Target
}

public protocol OpticsType: SimpleOpticsType {
	associatedtype AltSource
	associatedtype AltTarget
}
