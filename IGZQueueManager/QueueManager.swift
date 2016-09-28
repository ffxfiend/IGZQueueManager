//
//  QueueManager.swift
//  IGZQueueManager
//
//  Created by Jeremiah Poisson on 9/27/16.
//  Copyright © 2016 Jeremiah Poisson. All rights reserved.
//

import Foundation

// MARK: - Types  -
public typealias IGZNetworkSuccess = ((Any?) -> Void)?
public typealias IGZNetworkFailure = ((NSError?) -> Void)?
public typealias IGZQueueName = String

// MARK: - Errors -
public enum IGZ_NetworkErrors : Error {
	
	// Queue Errors
	case queueNameUnavailable
	case queueDoesNotExists
	case cannotRemoveDefaultQueue
	
	// Request Errors
	case requestHandlerNotSet
	case requestUnknownError
	case requestQueueDoesNotExist
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
	
	public init() {
		
		// Empty the queue, just in case
		queues.removeAll()
		
		// We can ignore the exception when adding the default queue as nothing is in the queue.
		try! self.addQueue(queue: DispatchQueue(label: "com.igzactly.network.general", attributes: []), name: GENERAL_QUEUE_NAME)
		
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
	
	
}
