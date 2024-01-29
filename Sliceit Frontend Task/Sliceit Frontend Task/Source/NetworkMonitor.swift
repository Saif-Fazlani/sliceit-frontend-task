//
//  NetworkMonitor.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 29/01/2024.
//

import Foundation
import Network

protocol NetworkMonitor: AnyObject {
    func startMonitoring()
    func stopMonitoring()
    func checkIfOnline() throws
}

extension NWInterface.InterfaceType: CaseIterable {
    public static var allCases: [NWInterface.InterfaceType] = [
        .other,
        .wifi,
        .cellular,
        .loopback,
        .wiredEthernet
    ]
}

final class NetworkMonitorImpl: NetworkMonitor {
    private let queue = DispatchQueue(label: "com.sliceit.networkMonitor")
    private let monitor: NWPathMonitor
    
    private(set) var isConnected = false
    private(set) var currentConnectionType: NWInterface.InterfaceType?
    
    init() {
        monitor = NWPathMonitor()
        startMonitoring()
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status != .unsatisfied
            self?.currentConnectionType = NWInterface.InterfaceType.allCases.filter { path.usesInterfaceType($0) }.first
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
    
    func checkIfOnline() throws {
        guard isConnected else {
            throw HTTPAsyncRequestError.noInternetConnection
        }
    }
}
