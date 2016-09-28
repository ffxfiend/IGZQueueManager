//
//  Package.swift
//  IGZQueueManager
//
//  Created by Jeremiah Poisson on 9/28/16.
//  Copyright © 2016 Jeremiah Poisson. All rights reserved.
//

import Foundation

/**
This enum represents the available package methods.
*/
public enum PackageMethod : String {
	case get = "GET"
	case post = "POST"
	case put = "PUT"
	case delete = "DELETE"
	
	/**
	Convienience method to retrieve the string associated with a
	particular package method.
	
	- returns: String
	*/
	func string() -> String {
		return self.rawValue
	}
}

/**
This structure represents a network package.
*/
public struct Package {
	
	public let action : URL
	public let method : PackageMethod
	public let queue : IGZQueueName
	public var parameters : PackageParams = [:]
	public var headers : PackageHeaders = [:]
	public let success : IGZNetworkSuccess
	public let failure : IGZNetworkFailure
	
	/**
	Convienience method to retrieve the string associated with a
	particular request method. This just calls the `getMethod`
	function from the `RequestMethod` enum.
	
	- returns: String
	*/
	public func getMethod() -> String {
		return method.string()
	}
	
}

