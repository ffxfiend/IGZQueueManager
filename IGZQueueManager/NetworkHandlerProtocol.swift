//
//  NetworkHandlerProtocol.swift
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

public protocol IGZNetworkHandlerProtocol {
	
	/**
	You must implement this protocol method on one of your own objects. This
	method will be called from the network manager when a request is initiated
	and ready to send. If you do not implement this method no network communication
	will occur via the network manager.
	
	- parameter request: The `Package` object to process via the network handler
	*/
	func send(_ package: Package)
	
}

