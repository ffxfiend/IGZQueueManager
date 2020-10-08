//
//  IGZQueueManagerPackageTests.swift
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

class IGZQueueManagerPackageTests: XCTestCase {
	
	var manager : QueueManager?
	let googleURL = URL(string: "http://www.google.com")!
	let stubNetworkHandler = StubNetworkHandler()
	var preparedPackageDefaultQueue : Package?
	var preparedPackageCustomQueue : Package?
	
    override func setUp() {
        super.setUp()
		
		// We want a new manager for each test, not a shared one.
		manager = IGZQueueManager.QueueManager()
		
		preparedPackageDefaultQueue = Package(action: googleURL, method: .get, queue: "GENERAL", parameters: [:], headers: [:], success: { (response: Any?) in
			}, failure: { (error: NSError?) in
		})
		
		preparedPackageCustomQueue = Package(action: googleURL, method: .get, queue: "My Custom Queue", parameters: [:], headers: [:], success: { (response: Any?) in
			}, failure: { (error: NSError?) in
		})
		
    }
    
    override func tearDown() {
        super.tearDown()
		manager!.removeAllQueues()
    }
	
	// MARK: - Preferred Create Package Method -
	func testCreatePackageSuccess() {
		
		// Set the network handler
		manager!.setNetworkHandler(stubNetworkHandler)
		
		XCTAssertNotNil(try? manager!.createPackage(googleURL, method: .get, queue: nil, params: [:], success: { (response: Any?) in
			
			}, failure: { (error: NSError?) in
			
		}))
		
	}
	
	func testCreatePackageHandlerNotSet() {
		
		XCTAssertThrowsError(try manager!.createPackage(googleURL, method: .get, queue: nil, params: [:], success: { (response: Any?) in
			
			}, failure: { (error : NSError?) in
				
		}), "Package Handler Not Set") { (error) in
			XCTAssertEqual(error as? IGZ_NetworkErrors, IGZ_NetworkErrors.packageHandlerNotSet)
		}
		
	}
	
	func testCreatePackageQueueDoesNotExist() {
		
		// Set the network handler
		manager!.setNetworkHandler(stubNetworkHandler)
		
		XCTAssertThrowsError(try manager!.createPackage(googleURL, method: .get, queue: "My Custom Queue", params: [:], success: { (response: Any?) in
			
			}, failure: { (error : NSError?) in
				
		}), "Queue does not exist") { (error) in
			XCTAssertEqual(error as? IGZ_NetworkErrors, IGZ_NetworkErrors.queueDoesNotExists)
		}
		
	}
	
	// MARK: - Create Package with Package -
	func testCreatePackageWithPackageSuccess() {
		// Set the network handler
		manager!.setNetworkHandler(stubNetworkHandler)
		
		XCTAssertNotNil(try? manager!.createPackage(preparedPackageDefaultQueue!))
		
	}
	
	func testCreatePackageWithPackageHandlerNotSet() {
		
		XCTAssertThrowsError(try manager!.createPackage(preparedPackageDefaultQueue!), "Package Handler Not Set") { (error) in
			XCTAssertEqual(error as? IGZ_NetworkErrors, IGZ_NetworkErrors.packageHandlerNotSet)
		}
		
	}
	
	func testCreatePackageWithPackageQueueDoesNotExist() {
		
		// Set the network handler
		manager!.setNetworkHandler(stubNetworkHandler)
		
		XCTAssertThrowsError(try manager!.createPackage(preparedPackageCustomQueue!), "Queue does not exist") { (error) in
			XCTAssertEqual(error as? IGZ_NetworkErrors, IGZ_NetworkErrors.queueDoesNotExists)
		}
	}
	
	// MARK: - Success Called - 
	func testPackageSuccessCalled() {
		
		// Set the network handler
		manager!.setNetworkHandler(stubNetworkHandler)
		
		let successExpectation = expectation(description: "Network Handler should be called and return a success state.")
		
		try! manager!.createPackage(googleURL, method: .get, queue: nil, params: ["success":true], success: { (response: Any?) in
			successExpectation.fulfill()
		}, failure: { (error: NSError?) in
			
		})
		
		waitForExpectations(timeout: 1) { (error: Error?) in
			if error != nil {
                XCTFail("waitForExpectations failed: \(error!.localizedDescription)")
			}
		}
		
	}
	
	
	func testPackageFailureCalled() {
		// Set the network handler
		manager!.setNetworkHandler(stubNetworkHandler)
		
		let failureExpectation = expectation(description: "Network Handler should be called and return a failure state.")
		
		try! manager!.createPackage(googleURL, method: .get, queue: nil, params: ["success":false], success: { (response: Any?) in
			
			}, failure: { (error: NSError?) in
				failureExpectation.fulfill()
		})
		
		waitForExpectations(timeout: 1) { (error: Error?) in
			if error != nil {
                XCTFail("waitForExpectations failed: \(error!.localizedDescription)")
			}
		}
		
		
	}
	
	
	
}
