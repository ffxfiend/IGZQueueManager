//
//  IGZQueueManagerQueueTests.swift
//  IGZQueueManager
//
//  Created by Jeremiah Poisson on 10/4/16.
//  Copyright © 2016 Jeremiah Poisson. All rights reserved.
//

import XCTest
@testable import IGZQueueManager

class IGZQueueManagerQueueTests: XCTestCase {
	
	var manager : QueueManager = IGZQueueManager.QueueManager.manager
	let defaultQueueName = "GENERAL"
	let customQueueName = "My Custom Queue"
	
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
		manager.removeAllQueues()
    }
	
	// MARK: - Create Queue -
	func testCreateQueueSuccess() {
		XCTAssertNotNil(try? manager.createQueue(customQueueName))
	}
	
	func testCreateQueueFailed() {
		XCTAssertThrowsError(try manager.createQueue(defaultQueueName))
	}
	
	// MARK: - Add Queue -
	func testAddQueueSuccess() {
		let queue = DispatchQueue(label: "com.igzactly.tests.custom_queue", attributes: [])
		XCTAssertNotNil(try? manager.addQueue(queue: queue, name: customQueueName))
	}
	
	func testAddQueueFailed() {
		let queue = DispatchQueue(label: "com.igzactly.tests.custom_queue", attributes: [])
		try! manager.addQueue(queue: queue, name: customQueueName)
		
		// Lets try to add the same one again.
		XCTAssertThrowsError(try manager.addQueue(queue: queue, name: customQueueName))
	}
	
	// MARK: - Removing Queues -
	func testRemoveQueueSuccess() {
		try! manager.createQueue(customQueueName)
		XCTAssertNotNil(try? manager.removeQueue(customQueueName))
	}
	
	func testRemoveDefaultQueue() {
		XCTAssertThrowsError(try manager.removeQueue(defaultQueueName), "Cannot remove default queue") { (error) in
			XCTAssertEqual(error as? IGZ_NetworkErrors, IGZ_NetworkErrors.cannotRemoveDefaultQueue)
		}
	}
	
	func testRemoveQueueThatDoesNotExist() {
		XCTAssertThrowsError(try manager.removeQueue(customQueueName))
	}
	
	// MARK: - Getting Queues - 
	func testGetQueueSuccess() {
		try! manager.createQueue(customQueueName)
		XCTAssertNotNil(try? manager.getQueue(customQueueName))
	}
	
	func testGetQueueThatDoesNotExist() {
		XCTAssertThrowsError(try manager.getQueue(customQueueName))
	}
	
}
