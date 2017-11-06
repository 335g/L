//  Copyright © 2017 Yoshiki Kudo. All rights reserved.

public protocol SimpleOpticsProtocol {
	associatedtype Source
	associatedtype Target
}

public protocol OpticsProtocol: SimpleOpticsProtocol {
	associatedtype AltSource
	associatedtype AltTarget
}
