//
//  EBNetworkManager.swift
//  EBless
//
//  Created by Amit Kumar Singh on 26/04/22.
//

import Foundation

typealias APIResponse = (Result<JSON,Error>)->Void

class NetworkManager {
    
    static let sharedInstance  = NetworkManager()
    
    enum ManagerErrors: Error {
        case invalidResponse
        case invalidStatusCode(Int)
    }
    
    enum HttpMethod: String {
        case get
        case post
        var method: String { rawValue.uppercased() }
    }
    
    static func requestGet(fromURL url: URL, httpMethod: HttpMethod = .get, completion: @escaping APIResponse) {
        let completionOnMain: APIResponse = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.method
        networkSupport(request: request, completionOnMain:completionOnMain)
    }
    
    static func requestPost(fromURL url: URL, httpMethod: HttpMethod = .post, completion: @escaping APIResponse) {
        let completionOnMain: APIResponse = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.method
        networkSupport(request: request, completionOnMain:completionOnMain)
    }
    
    static func networkSupport(request:URLRequest,completionOnMain:@escaping APIResponse){
        
        let urlSession = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completionOnMain(.failure(error))
                return
            }
            
            guard let urlResponse = response as? HTTPURLResponse else { return completionOnMain(.failure(ManagerErrors.invalidResponse)) }
            
            if !(200..<300).contains(urlResponse.statusCode) {
                return completionOnMain(.failure(ManagerErrors.invalidStatusCode(urlResponse.statusCode)))
            }
            do {
                guard let data = data else {  return }
                let jsonDict =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                  completionOnMain(.success(JSON(jsonDict)))
            } catch {
                debugPrint("Error: \(error.localizedDescription)")
                completionOnMain(.failure(error))
            }
        }
        urlSession.resume()
    }
    
    func parseJSON() {
        guard let path = Bundle.main.path(forResource: "Country", ofType: "json")
        else {
            return
        }
        let url = URL(fileURLWithPath: path)
        
        do{
            let jsonData = try Data(contentsOf: url)
            var result = try JSONDecoder().decode([CountryCode].self, from: jsonData)
            result = result.sorted{$0.code < $1.code}
            countryData = result
            countryData = countryData.sorted{$0.name < $1.name }
        }
        catch(let error){
            print(error)
        }
    }
}
