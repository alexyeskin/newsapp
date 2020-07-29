//
//  LocationCore.swift
//  NewsApp
//
//  Created by Alexander Eskin on 12/8/19.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import Foundation

protocol LocationCore {
    var locationHandler: ((Result<Location, LocationError>) -> Void)? { get set }
    
    func getLocation(completion: @escaping (Result<Location, LocationError>) -> Void)
    func geocodeLocation(location: Location, completion: @escaping (String) -> Void)
}
