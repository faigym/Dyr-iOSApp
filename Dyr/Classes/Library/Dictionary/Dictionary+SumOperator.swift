//
//  Dictionary+SumOperator.swift
//  Dyr
//
//  Created by Pieter Maene on 12/04/15.
//  Copyright (c) 2015 Student IT vzw. All rights reserved.
//

import Foundation

func +<K, V>(left: [K: V], right: [K: V]) -> [K: V] {
    var result: [K: V] = left
    for (k, v) in right {
        result[k] = v
    }
    
    return result
}

func +=<K, V> (inout left: [K: V], right: [K: V]) {
    for (k, v) in right {
        left[k] = v
    }
}
