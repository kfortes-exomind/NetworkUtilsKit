//
//  MockProtocol.swift
//  NetworkUtilsKit
//
//  Created by Michael Coqueret on 21/01/2021.
//  Copyright © 2021 RGMC. All rights reserved.
//

import Foundation
import OSLog

#if canImport(UtilsKitCore)
import UtilsKitCore
#endif

#if canImport(UtilsKit)
import UtilsKit
#endif

/// This protocol represents a mocked request to execute
public protocol MockProtocol: RequestProtocol {
    
    /// Mock file if needed
    var mockFileURL: URL? { get }
}

extension RequestProtocol where Self: MockProtocol {
    
    // MARK: Mock
    /**
     Send request and return mocked response or error
     */
    public func mock() async throws -> NetworkResponse {
        guard let mockPath = self.mockFileURL else {
			Logger.mock.fault("\(self.description) - \(ResponseError.noMock.localizedDescription)")
            throw ResponseError.noMock
        }
        
        do {
            let data = try Data(contentsOf: mockPath, options: .mappedIfSafe)
			Logger.mock.notice("\(self.description)")
            return (200, data)
        } catch {
			Logger.mock.fault("\(self.description) - \(error.localizedDescription)")
            throw error
        }
    }
    
    /**
     Get the mocked decoded response of type `T`with progress
     */
    public func mock<T: Decodable>(_ type: T.Type) async throws -> T {
        
        let response = try await self.mock()
        
        guard let data = response.data else { throw ResponseError.data }
        
        do {
            return try T.decode(from: data)
        } catch {
            let responseError = ResponseError.decodable(type: "\(T.self)")
			Logger.requestFail.notice("\(self.description)")
            throw responseError
        }
    }
}
