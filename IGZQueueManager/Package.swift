//
//  Package.swift
//  IGZQueueManager
//
//  Created by Jeremiah Poisson on 9/28/16.
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

