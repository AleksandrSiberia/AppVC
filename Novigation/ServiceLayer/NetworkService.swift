//
//  NetworkService.swift
//  Novigation
//
//  Created by Александр Хмыров on 01.03.2023.
//

import Foundation
import Network



final class NetworkService {

    let networkMonitor = NWPathMonitor()

    var statusNetworkIsSatisfied: Bool = false

    static var shared = NetworkService()



    func startMonitoring() {

        networkMonitor.pathUpdateHandler = { path in

            self.statusNetworkIsSatisfied = path.status != .unsatisfied
        }

        networkMonitor.start(queue: DispatchQueue(label: "serial"))
    }

    

    func stopMonitoring() {
        networkMonitor.cancel()
    }
}
