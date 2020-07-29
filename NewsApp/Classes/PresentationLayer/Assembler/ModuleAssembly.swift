//
//  ModuleAssembly.swift
//  NewsApp
//
//  Created by Alexander Eskin on 12.12.2019.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import Swinject

class ModuleAssembly {
    fileprivate let assembler: Assembler!
    
    public var resolver: Resolver {
        return assembler.resolver
    }
    
    init(parent: Assembler) {
        assembler = Assembler(
            [
                RootModuleAssembler(),
                NewsModuleAssembler(),
                NewsDetailsModuleAssembler()
            ], parent: parent
        )
    }
}
