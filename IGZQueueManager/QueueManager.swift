//
//  QueueManager.swift
//  IGZQueueManager
//
//  Created by Jeremiah Poisson on 9/27/16.
//  Copyright © 2016 Jeremiah Poisson. All rights reserved.
//

import Foundation

open class QueueManager {
	
	open static let manager = QueueManager()
	
	fileprivate var stateBool : Bool
	
	public init() {
		
		self.stateBool = true
		
	}
	
	open func setState(_ state: Bool) {
		self.stateBool = state
	}
	
	open func getState() -> Bool {
		return self.stateBool
	}
	
	
}
