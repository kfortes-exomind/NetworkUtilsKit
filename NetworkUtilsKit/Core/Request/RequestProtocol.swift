//
//  RequestProtocol.swift
//  UtilsKit
//
//  Created by RGMC on 18/10/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import Foundation

/// This protocol represents a full request to execute
public protocol RequestProtocol {
    
    /// Request scheme
    var scheme: String { get }
    
    /// Request host
    var host: String { get }
    
    /// Request path
    var path: String { get }
    
    /// Request method
    var method: RequestMethod { get }
    
    /// Request headers if needed
    var headers: Headers? { get }
    
    /// Request parameters if needed
    var parameters: Parameters? { get }
    
    /// Request encoding
    var encoding: Encoding { get }
    
    /// Request authentification if needed
    var authentification: AuthentificationProtocol? { get }
    
    /// Cache key if needed
    var cacheKey: String? { get }
    
    /// Request queue
    var queue: DispatchQueue { get }
    
    /// Request identifier
    var identifier: String? { get }
}

extension RequestProtocol {
    
    /// Request headers if needed
    public var headers: Headers? { nil }
    
    /// Request parameters if needed
    public var parameters: Parameters? { nil }
    
    /// Request encoding
    public var encoding: Encoding { .url }
    
    /// Request authentification if needed
    public var authentification: AuthentificationProtocol? { nil }
    
    /// Cache key if needed
    public var cacheKey: String? { nil }
    
    /// Request queue. Main by default
    public var queue: DispatchQueue { DispatchQueue.main }
    
    /// Request identifier
    public var identifier: String? { nil }
    
    /**
        Send request and return response or error
     */
    public func responseData(completion: ((Result<NetworkResponse, Error>) -> Void)? = nil) {
        RequestManager.shared.request(self) { result in
            switch result {
            case .success(let response):
                if let cacheKey = self.cacheKey {
                    NetworkCache.shared.set(response.data, for: cacheKey)
                }
                completion?(result)
                
            case .failure(let error):
                if let cacheKey = self.cacheKey, let data = NetworkCache.shared.get(cacheKey) {
                    completion?(.success((statusCode: (error as? RequestError)?.statusCode, data: data)))
                } else {
                    completion?(result)
                }
            }
        }
    }
    
    
    /**
        Send request and return  error if failed
     */
    public func send(completion: ((Result<Void, Error>) -> Void)? = nil) {
        self.responseData { result in
            switch result {
            case .success: completion?(.success(()))
            case .failure(let error): completion?(.failure(error))
            }
        }
    }
    
    /**
     Download request
     - parameter URL : URL
     - parameter result: Download Result
     - parameter progress: Download progress
     
     */
    public func download(at URL: URL,
                         completion: ((Result<Int, Error>) -> Void)? = nil,
                         progress: ((URLSessionDownloadTask) -> Void)? = nil) {
        RequestManager.shared.download(at: URL, request: self, result: completion, progress: progress)
    }
}

extension RequestProtocol {
    
    /**
        Clear request cache
     */
    public func clearCache() {
        guard let cacheKey = self.cacheKey else { return }
        NetworkCache.shared.delete(cacheKey)
    }
}
