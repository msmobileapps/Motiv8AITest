//
//  WebSocketManager.swift
//  Motiv8AI
//
//  Created by MSApps on 21/01/2021.
//

import Foundation

class WebSocketManager{
    
    let jsonDecoder = JSONDecoder()
    var webSocketTask: URLSessionWebSocketTask?
    let urlSession = URLSession(configuration: .default)
    public static let sharedInstance = WebSocketManager()
    
    private init(){}
    
    func stopConnection(){
        if let task = webSocketTask{
            task.cancel(with: .goingAway, reason: nil)
        }
    }
    
    func startConnection(){
        webSocketTask = urlSession.webSocketTask(with: URL(string: Constants.webSocketUrl)!)
        if let task = webSocketTask{
            task.resume()
        }
    }
    
    func getData(completion: @escaping (_ item: ListItem?) -> Void){
        guard let task = webSocketTask else {
            return
        }
        task.receive { [self]  result in
            switch result {
            case .failure(let error):
                print("Failed to receive message: \(error)")
            case .success(let message):
                switch message {
                case .string(let jsonData):
                    let listItem = decodeFromString(jsonString: jsonData)
                    DispatchQueue.main.async {
                        completion(listItem)
                    }
                case .data(let data):
                    print("Received binary message: \(data)")
                @unknown default:
                    print("Received unknown message")
                }
            }
        }
    }
    
    func decodeFromString(jsonString: String) -> ListItem?{
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let item = try decoder.decode(ListItem.self, from: Data(jsonString.utf8))
            return item
        }catch{
            return nil
        }
    }
}
