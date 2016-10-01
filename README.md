# IGZQueueManager

A simple swift framework to filter network calls across multiple queues. It is designed to be used with any existing or homegrown networking library. IGZQueueManager will also allow  you to apply any form of authentication to a network request. It is meant to be simple and came from a set of code I always used when managing network calls to the API's I work with.


## How to Install

IGZQueueManager is best installed using the  **Carthage** package manager. For more information on **Carthage** check out their github page. 

- https://github.com/Carthage/Carthage

### Carthage 
Add the following line to your `Cartfile`

```ogdl
github "ffxfiend/IGZQueueManager" ~> 1.0
```

## How to Use

### SetUp

In your AppDelegate add the following import statement

```swift
import IGZQueueManager
```

In the `application(_:didFinishLaunchingWithOptions:)` method in your `AppDelegate` use the following to initiate the manager.

```swift
// This will create the shared instance of the manager.
// The manager comes with a default queue with the name "GENERAL".
let manager = IGZQueueManager.QueueManager.manager;

// Add a custom queue. 
// If a queue with the name already exists the method
// will throw an exception. 
try! manager.createQueue("Custom Queue Name")

// Pass it an instance of your Network Handler that adheres to the "IGZNetworkHandlerProtocol".
let networkHandler = NetworkHandler()
manager.setNetworkHandler(networkHandler)

// Optionally set the authentication handler if your network call required it. 
let authenticationHandler = AuthenticationHandler()
manager.setAuthenticationHandler(authenticationHandler)
```

This is the minimum you need to set up the manager. 

## Network Handler
The network handler is a custom class that you write and will allow you to use your networking library of choice. The only method required of this class is the `send(_:)` method. You can use the following as a simple template.

```swift
import IGZQueueManager
// Import your network library of choice here

class NetworkHandler : IGZNetworkHandlerProtocol {
func send(_ package: Package) {
// Your network code here
}
}
```

The queue manager will send a call to this method when a package reaches the head of the queue. 

## Authentication Handler
The authentication handler is a custom class that adheres to the `IGZNAuthenticationProtocol`.  It requires only a single method. This method will be called before the `IGZNetworkHandlerProtocol send(_:)`  method. You can use it to apply whatever type of authentication you need for the network request. The following is a simple template.

```swift
import IGZQueueManager

class AuthenticationHandler : IGZNAuthenticationProtocol {
func applyAuthentication(_ package: inout Package) {
// Your authentication code here
}
}
```

## Queueing a request
You can queue up a request using one of the two following methods.

- `createPackage(_:method:queue:params:success:failure:)`
- `createPackage(_:)`

#### createPackage(_:method:queue:params:success:failure:)

This is the preferred method to queue up a request. You pass it the URL, method, queue, params an a success and failure handler. 

```swift
try! manager.createPackage(url, method: .get, queue: "Custom Queue", params: [:], success: { (response: Any?) in
// Handle the success case
}) { (error: NSError?) in
// Handle the failure case
}
```

#### createPackage(_:)
This method can be used if you either already have a package object that you need to try to send again in case of a network failure or if you create the package manually. 

```swift
let package = Package(action: url, method: .get, queue: "Custom Queue", parameters: [:], headers: [:], success: { (response: Any?) in
// Handle success here
}, failure: { (error: NSError?) in
// Handle failure here
})
try! manager.createPackage(package)
```

#### Errors
Both create methods will throw the following errors.

- `IGZ_NetworkErrors.packageHandlerNotSet` if the network handler has not been set
- `IGZ_NetworkErrors.queueDoesNotExists` if the requested queue does not exist
- `IGZ_NetworkErrors.packageUnknownError` if an unknown error occurs. This should never be thrown...

## Creating Queues
Use the following methods to create a custom queue.

- `createQueue(_:)`
- `addQueue(queue:name:)`

#### createQueue(_:)
This is the preferred and easiest way to create a queue. All you need to do it pass it a name and it will create the queue if able. 

```swift
try! manager.createQueue("Custom Queue Name")
```

This method will throw the `IGZ_NetworkErrors.QueueNameUnavailable` error if the name of the queue you are trying to create already exists. 

#### addQueue(queue:name:)
You can use this method if you want to create and manage your own `DispatchQueue`. 

```swift
try! manager.addQueue(queue: DispatchQueue(label: "queue.label", attributes: []), name: "Custom Queue Name");
```

This method will throw the `IGZ_NetworkErrors.QueueNameUnavailable` error if the name of the queue you are trying to create already exists. 

## Remove Queues
You can remove a queue using the `removeQueue(_:)` method.

```swift
try! manager.removeQueue("Custom Queue Name")
```

This method can throw the following errors.

- `IGZ_NetworkErrors.CannotRemoveDefaultQueue` if you are trying to remove the general queue
- `IGZ_NetworkErrors.QueueDoesNotExists` if the queue you are trying to remove does not exist

## Retrieving Queues
You can get the underlying `DispatchQueue` from the manager with the `getQueue(_:)` method.

```swift
try! let queue = manager.getQueue("Custom Queue Name")
```

This method can throw the `IGZ_NetworkErrors.QueueDoesNotExists` error if the queue you are trying to retrieve does not exist.

## Sample Handlers
**Note: These sample handlers will be included in the `sample` folder soon.**

- AlamofireNetworkHandler
- This handler will interface with the **Alamofire** networking library version 4.0 and greater. https://github.com/Alamofire/Alamofire
- OAuth2AuthenticationHandler
- This Authentication handler will apply the proper OAuth 2 headers

## Licence
IGZQueueManager is released under the MIT license. See LICENSE for details.

> Written with [StackEdit](https://stackedit.io/).
