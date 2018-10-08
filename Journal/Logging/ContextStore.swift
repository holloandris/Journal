//
//  ContextStore.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 09. 03..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

protocol ContextStore {
    func addContext(_ context:String)
    func getContext()
}