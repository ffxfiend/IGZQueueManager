//
//  AuthenticationProtocol.swift
//  IGZQueueManager
//
//  Created by Jeremiah Poisson on 9/28/16.
//  Copyright © 2016 Jeremiah Poisson. All rights reserved.
//

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
