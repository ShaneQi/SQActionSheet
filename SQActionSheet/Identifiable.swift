//
//  Identifiable.swift
//  SQITools
//
//  Created by Shane Qi on 4/10/17.
//  Copyright © 2017 Shane Qi. All rights reserved.
//
public protocol Identifiable: class {
    
    static var identifier: String { get }
    
}

public extension Identifiable {
    
    /// The default implementation use the class name as the identifier, this is usually used
    /// in reusable view classes (like UICollectionViewCell, UITableViewCell, etc).
    static var identifier: String { return String(describing: Self.self) }
    
}
