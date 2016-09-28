//
//  NetworkHandlerProtocol.swift
//  IGZQueueManager
//
//  Created by Jeremiah Poisson on 9/28/16.
//  Copyright © 2016 Jeremiah Poisson. All rights reserved.
//

import Foundation

public protocol IGZNetworkHandlerProtocol {
	
	/**
	You must implement this protocol method on one of your own objects. This
	method will be called from the network manager when a request is initiated
	and ready to send. If you do not implement this method no network communication
	will occur via the network manager.
	
	- parameter request: The `IGZRequest` object to process via the network handler
	*/
	func send(_ request: Package)
	
}

