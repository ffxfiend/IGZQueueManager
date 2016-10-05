//
//  IGZQueueManagerQueueTests.swift
//  IGZQueueManager
//
//  Created by Jeremiah Poisson on 10/4/16.
//
//  Copyright (c) 2016 Jeremiah Poisson (http://miahpoisson.com)
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.

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
