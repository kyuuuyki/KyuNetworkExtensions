//
//  DefaultNetworkProvider.swift
//  KyuNetworkExtensions
//
//  Created by Chayanon Ardkham on 6/10/20.
//

import Foundation

import Moya
import ObjectMapper

public class DefaultNetworkProvider<T: TargetType> {
    
    private var provider: MoyaProvider<T>!
    private weak var configurator: DefaultNetworkProviderConfigurator?
    
    public convenience init(configurator: DefaultNetworkProviderConfigurator? = nil) {
        self.init()
        
        self.provider = MoyaProvider<T>()
        self.configurator = configurator
    }
    
    private func performRequest(route: T, success: @escaping (Response) -> Void, error: @escaping (Error) -> Void) {
        
        //PerformRequest
        self.provider.request(route) { (result) in
            switch result {
            case let .success(response):
                success(response)
            case let .failure(err):
                error(err)
            }
        }
    }
    
    public func requestPlain(route: T, success: @escaping (Response) -> Void, error: @escaping (Error) -> Void) {
        if let configurator = configurator {
            configurator.requestPrerequisiteProcesses(completion: {
                self.performRequest(route: route, success: success, error: error)
            })
        }
        else {
            performRequest(route: route, success: success, error: error)
        }
    }
    
    public func requestObject<U: BaseMappable>(type: U.Type, route: T, success: @escaping (U) -> Void, error: @escaping (Error) -> Void) {
        requestPlain(route: route, success: { (response) in
            var object: U?
            if let serializedJson = try? JSONSerialization.jsonObject(with: response.data, options: .allowFragments) as? [String: Any], let serializedObject = Mapper<U>().map(JSONObject: serializedJson) {
                object = serializedObject
            }
            object != nil ? success(object!) : error(NSError(domain: "Cannot Map Object!", code: response.statusCode, userInfo: nil))
        }, error: { (err) in
            error(NSError(domain: err.localizedDescription, code: err.asAFError?.responseCode ?? 500, userInfo: nil))
        })
    }
    
    public func requestObjects<U: BaseMappable>(type: U.Type, route: T, success: @escaping ([U]) -> Void, error: @escaping (Error) -> Void) {
        requestPlain(route: route, success: { (response) in
            var objects = [U]()
            if let serializedJson = try? JSONSerialization.jsonObject(with: response.data, options: .allowFragments) as? [[String: Any]], let serializedObjects = Mapper<U>().mapArray(JSONObject: serializedJson) {
                objects = serializedObjects
            }
            success(objects)
        }, error: { (err) in
            error(NSError(domain: err.localizedDescription, code: err.asAFError?.responseCode ?? 500, userInfo: nil))
        })
    }
}
