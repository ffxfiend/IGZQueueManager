//
//  AlamofireHandler.swift
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

import Foundation
import IGZQueueManager
import Alamofire

class AlamofireHandler : IGZNetworkHandlerProtocol {
	
	func send(_ package: Package) {
		
		// Prorcess the package and send it along to alamofire to make the actual network request
		let debugInfo = Alamofire.request(package.action, method: getAlamoMethodType(package.method), parameters: package.parameters, encoding: URLEncoding.default, headers: package.headers).responseJSON { (response: DataResponse<Any>) in
			
			guard let statusCode = self.getStatusCode(response) else {
				package.failure(NSError(domain: "Error Domain", code: -9999, userInfo: nil))
				return
			}
			
			if (response.result.isSuccess) {
				// We have a valid code between 200...299, Process the code.
				package.success(response.result.value)
			} else {
				// Something went wrong, handle the error.
				switch statusCode {
				case 400:
					package.failure(NSError(domain: "Error Domain", code: 400, userInfo: nil))
					break;
				case 500:
					package.failure(NSError(domain: "Error Domain", code: 500, userInfo: nil))
					break;
				default:
					package.failure(NSError(domain: "Error Domain", code: statusCode, userInfo: nil))
					break;
				}
			}
			
			}.debugDescription
		
		print(debugInfo)
		
	}
	
	// Conversion method for Alamofire. Their may be a better way to do this... ...
	func getAlamoMethodType(_ method: PackageMethod) -> HTTPMethod {
		switch method {
		case .post:
			return .post
		case .put:
			return .put
		case .delete:
			return .delete
		default:
			return .get
		}
	}
	
	func getStatusCode(_ response: DataResponse<Any>) -> Int? {
		
		guard response.response != nil else {
			return nil
		}
		return response.response!.statusCode
		
	}
	
}
