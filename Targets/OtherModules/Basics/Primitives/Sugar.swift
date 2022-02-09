//
//  Sugar.swift
//  GEBase
//
//  Created by Grigory Entin on 27/06/16.
//  Copyright © 2016 Grigory Entin. All rights reserved.
//

import Foundation

//
// The idea is borrowed from https://github.com/devxoul/Then
//

infix operator ≈
infix operator …

@discardableResult
public func with<T: AnyObject>(_ obj: T, _ body: (T) throws -> Void) rethrows -> T {
	try body(obj)
	return obj
}
public func with<T>(_ value: T, _ body: (inout T) throws -> Void) rethrows -> T {
	var valueCopy = value
	try body(&valueCopy)
	return valueCopy
}

public func ≈<T>(value: T, body: (inout T) throws -> Void) rethrows -> T {
	// swiftlint:disable:previous identifier_name
	return try with(value, body)
}
@discardableResult
public func …<T: AnyObject>(obj: T, body: (T) throws -> Void) rethrows -> T {
	// swiftlint:disable:previous identifier_name
	return try with(obj, body)
}

/**
	Substitute for `Void` in `static let initializeOnce: Void = {...}`.
	
	`Void` breaks LLDB interactions when `initializeOnce` is visible as below:

		(lldb) p tableView.estimatedRowHeight
		error: Couldn't materialize: couldn't get the value of initializeOnce: extracting data from value failed
		error: errored out in DoExecute, couldn't PrepareToExecuteJITExpression
*/
public typealias Ignored = Int

public typealias UnusedKVOValue = AnyObject?
