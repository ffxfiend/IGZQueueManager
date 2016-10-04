//
//  QueueManager.swift
//  IGZQueueManager
//
//  Created by Jeremiah Poisson on 9/27/16.
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

import Foundation

// MARK: - Types  -
public typealias IGZNetworkSuccess = ((Any?) -> Void)
public typealias IGZNetworkFailure = ((NSError?) -> Void)
public typealias PackageParams = [String: Any]
public typealias PackageHeaders = [String: String]
public typealias IGZQueueName = String

// MARK: - Errors -
public enum IGZ_NetworkErrors : Error {
	
	// Queue Errors
	case queueNameUnavailable
	case queueDoesNotExists
	case cannotRemoveDefaultQueue
	
	// Package Errors
	case packageHandlerNotSet
	case packageUnknownError
	case packageQueueDoesNotExist
}

// MARK: - Queue Manager Class -

/**
 * Main manager class. This will handle the adding and removing of queues 
 * as well as calling the handlers to send the network call or apply any
 * needed Authentication.
 *
 * Calling `IGZQueue.QueueManager.manager` will give you the default shared
 * manager. If you want to create your own manager you can call `IGZQueue.QueueManager()`.
 *
 * The queue manager comes with a default queue names `GENERAL`.
 */
public class QueueManager {
	
	public static let manager = QueueManager()
	
	/// Flag indicating if debug mode is on
	fileprivate var debug : Bool = false
	
	/// Default Queue that willbe preloaded into the queues dict
	fileprivate var GENERAL_QUEUE_NAME : IGZQueueName = "GENERAL"
	
	/// Dict of queues that are available. Defaults with a general queue available
	fileprivate var queues : [String: DispatchQueue] = [String: DispatchQueue]()
	
	/// The handler responsible for making the network call
	fileprivate var networkHandler : IGZNetworkHandlerProtocol?
	
	/// The handler responsible for making any authentication adjustments to the package
	fileprivate var authenticationHandler : IGZNAuthenticationProtocol?
	
	public init() {
		self.removeAllQueues()
	}
	
}

// MARK: - Authentication extension -
extension QueueManager {
	
	/**
	Set the authentication handle to use. The handler must adhere to the `IGZNAuthenticationProtocol`.
	
	- parameter handler: The authentication handler
	*/
	public func setAuthenticationHandler<T: IGZNAuthenticationProtocol>(_ handler: T) {
		self.authenticationHandler = handler
	}
	
}

// MARK: - Network Handler Extentions -
extension QueueManager {
	
	/**
	Use this method to set the network handler to use. This handler will allow you to
	integrate this manager with any network system available. The handler needs to
	implement the `IGZNetworkHandlerProtocol` so the `IGZNetworkingQueue` can call
	your handler when making a network call.
	
	- parameter handler:	A custom class hooking this network manager up with another manager.
	*/
	public func setNetworkHandler<T: IGZNetworkHandlerProtocol>(_ handler: T) {
		self.networkHandler = handler
	}
	
	/**
	Use this method to make a network call.
	
	- throws:
		- `IGZ_NetworkErrors.packageHandlerNotSet` if the network handler has not been set
		- `IGZ_NetworkErrors.queueDoesNotExists` if the requested queue does not exist
		- `IGZ_NetworkErrors.packageUnknownError` if an unknown error occurs. This should never be thrown...
	
	- parameters:
		- url:		The `NSURL` the package is going to
		- method:	The type of request to make. Refer to `PackageMethod` for available types
		- queue:	The name of the queue to add the call into. This must be a `String`
		- params:	The parameter dictionary to send along with the package
		- success:	The success callback to make when the call has been successful
		- failure:	The failure callback to make when the call has failed for any reason
	*/
	public func createPackage(_ url: URL, method: PackageMethod, queue: IGZQueueName, params: PackageParams, success: @escaping IGZNetworkSuccess, failure: @escaping IGZNetworkFailure) throws {
		
		do {
			let package = Package(action: url, method: method, queue: queue, parameters: params, headers: [:], success: success, failure: failure)
			try queuePackage(package.queue, package: package)
		} catch IGZ_NetworkErrors.packageHandlerNotSet {
			throw IGZ_NetworkErrors.packageHandlerNotSet
		} catch IGZ_NetworkErrors.queueDoesNotExists {
			throw IGZ_NetworkErrors.queueDoesNotExists
		} catch {
			throw IGZ_NetworkErrors.packageQueueDoesNotExist
		}
		
	}
	
	/**
	This method will take a pre generated `Package` object to queue up for the network handler. Usually this is used
	if a network call has failed and we want to try to resend the same package again.
	
	- throws:
		- `IGZ_NetworkErrors.packageHandlerNotSet` if the network handler has not been set
		- `IGZ_NetworkErrors.queueDoesNotExists` if the requested queue does not exist
		- `IGZ_NetworkErrors.packageUnknownError` if an unknown error occurs. This should never be thrown...
	
	- parameter package:	The `Package` object to use in the network handler
	*/
	public func createPackage(_ package: Package) throws {
		
		do {
			try queuePackage(package.queue, package: package)
		} catch IGZ_NetworkErrors.packageHandlerNotSet {
			throw IGZ_NetworkErrors.packageHandlerNotSet
		} catch IGZ_NetworkErrors.queueDoesNotExists {
			throw IGZ_NetworkErrors.queueDoesNotExists
		} catch {
			throw IGZ_NetworkErrors.packageQueueDoesNotExist
		}
		
	}

	/**
	This private method takes in a package and applies any authentication adjustments, if
	defined, then calls the network handler to make the actual call.
	
	- parameter package: The `Package` object to use for the network call
	*/
	fileprivate func send(_ package: Package) {
		
		var req = package
		
		if authenticationHandler != nil {
			// Apply any authentication specific needs to the package.
			authenticationHandler!.applyAuthentication(&req);
		}
		
		// Call the main send function
		networkHandler!.send(req)
		
	}
	
}

// MARK: - Queue Management -
extension QueueManager {
	
	/**
	Use this method to have the network manager create a network queue for you and add it to the
	dictionary of available queues.
	
	- throws: `IGZ_NetworkErrors.QueueNameUnavailable` if the queue name is already taken
	
	- parameter name:	The name of the queue you want to create
	*/
	public func createQueue(_ name: IGZQueueName) throws {
		
		do {
			let queueName = name.replacingOccurrences(of: " ", with: "");
			try addQueue(queue: DispatchQueue(label: "com.igzactly.network.\(queueName)", attributes: []), name: name);
		} catch {
			throw IGZ_NetworkErrors.queueNameUnavailable
		}
		
		
	}
	
	/**
	Use this method to add a custom queue to the network manager. This is
	useful if you want to have some network calls run on a differnet
	queue then the default general queue provided.
	
	- parameters:
		- queue: The queue to add. Must be of type dispatch_queue_t
		- name:  The name you want to give the queue
	
	- throws: `IGZ_NetworkErrors.QueueNameUnavailable` if the queue name already exists
	*/
	public func addQueue(queue queueToAdd: DispatchQueue, name: IGZQueueName) throws {
		
		guard queues.index(forKey: name) == nil else {
			throw IGZ_NetworkErrors.queueNameUnavailable
		}
		
		queues[name] = queueToAdd
		
	}
	
	/**
	Use this method to remove a queue from the network manager. You are
	not allowed to remove the general (default) queue.
	
	- parameter name: The name of the queue to remove
	
	- throws:
		- `IGZ_NetworkErrors.CannotRemoveDefaultQueue` if you are trying to remove the general queue
		- `IGZ_NetworkErrors.QueueDoesNotExists` if the queue you are trying to remove does not exist
	*/
	public func removeQueue(_ name: IGZQueueName) throws {
		
		guard name != GENERAL_QUEUE_NAME else {
			throw IGZ_NetworkErrors.cannotRemoveDefaultQueue
		}
		
		guard let index = queues.index(forKey: name) else {
			throw IGZ_NetworkErrors.queueDoesNotExists
		}
		
		queues.remove(at: index)
		
	}
	
	public func removeAllQueues() {
		
		// Empty the queue, just in case
		queues.removeAll()
		
		// We can ignore the exception when adding the default queue as nothing is in the queue.
		try! self.addQueue(queue: DispatchQueue(label: "com.igzactly.network.general", attributes: []), name: GENERAL_QUEUE_NAME)
		
	}
	
	/**
	This method will return a `dispatch_queue_t` if it exists.
 
	- throws: `IGZ_NetworkErrors.QueueDoesNotExists` if the requested queue does not exist
	
	- parameter name: The name of the queue we want to retrieve.
	
	- returns: dispatch_queue_t
	*/
	public func getQueue(_ name: IGZQueueName) throws -> DispatchQueue {
		
		guard let queue = queues[name] else {
			throw IGZ_NetworkErrors.queueDoesNotExists
		}
		return queue;
		
	}
	
	/**
	This method takes a queue name and `Package` and inserts it into the appropriate queue to
	be called in order.
	
	- throws: 
		- `IGZ_NetworkErrors.packageHandlerNotSet` if the network handler is not set
		- `IGZ_NetworkErrors.queueDoesNotExists` if the queue does not eist
		- `IGZ_NetworkErrors.packageUnknownError` if an unknown error occurs. This should never be thrown...
	
	
	- parameters:
		- queue:	The name of the queue to add the package to
		- package:	The `Package` object to add to the queue
	*/
	fileprivate func queuePackage(_ queue: IGZQueueName, package: Package) throws {
		
		guard networkHandler != nil else {
			throw IGZ_NetworkErrors.packageHandlerNotSet
		}
		
		do {
			let networkQueue = try getQueue(queue)
			networkQueue.async(execute: {
				self.send(package)
			})
		} catch IGZ_NetworkErrors.queueDoesNotExists {
			throw IGZ_NetworkErrors.queueDoesNotExists
		} catch {
			throw IGZ_NetworkErrors.packageUnknownError
		}
		
	}
	
}
