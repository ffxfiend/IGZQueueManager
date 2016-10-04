//
//  StubNetworkHandler.swift
//  IGZQueueManager
//
//  Created by Jeremiah Poisson on 10/4/16.
//  Copyright © 2016 Jeremiah Poisson. All rights reserved.
//

import Foundation
import IGZQueueManager

class StubNetworkHandler : IGZNetworkHandlerProtocol {
	
	func send(_ package: Package) {
		
		guard let success = package.parameters["success"] as? Bool else {
			package.failure(nil)
			return
		}
		
		if (success) {
			package.success(nil)
		} else {
			package.failure(nil)
		}
		
	}
	
	
}
