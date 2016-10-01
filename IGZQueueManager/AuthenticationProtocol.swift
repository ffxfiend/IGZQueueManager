//
//  AuthenticationProtocol.swift
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

public protocol IGZNAuthenticationProtocol {
	func applyAuthentication(_ request: inout Package);
}

extension IGZNAuthenticationProtocol {
	
	/**
	This protocol method will take a request and allow you to manipulate it
	in an appropriate way to apply the correct type of authentication to it.
	
	For example, with OAuth 1 it could insert the OAuth 1 specific parameters
	and generate the signiture and attacj that as well. While with OAuth 2 it
	could create the necessary headers and apply them to the request.
	
	The actual implementation will depend on the handler used.
	
	- parameter request: `Package` object to apply authentication to
	*/
	public func applyAuthentication(_ package: inout Package) {
		// Default implementation does nothing.
	}
	
}
