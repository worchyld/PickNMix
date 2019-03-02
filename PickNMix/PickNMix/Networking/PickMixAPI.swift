//
//  PickMixAPI.swift
//  PickNMix
//
//  Created by Amarjit on 02/03/2019.
//  Copyright © 2019 Amarjit. All rights reserved.
//

import Foundation

struct Constants {
    class API {
        static let base: String = "http://concepting.foundersfactory.com/"
        static let endpoint: String = "demo/idea-generator/"
        static let timeout: TimeInterval = TimeInterval(integerLiteral: 20)
        static let mode: String = "json"

        static var url: URL? {
            guard let base = URL(string: Constants.API.base), let url = URL(string: Constants.API.endpoint, relativeTo: base) else {
                return nil
            }
            return url
        }
    }
}

class PickMixAPI {

    // lightweight request URL
    static func executeRequestURL(_ requestURL: URL, taskCallback: @escaping (Bool, Error?, Data?) -> ()) {
        print ("Attempting URL -- \(requestURL)")

        let request: URLRequest = URLRequest(url: requestURL as URL, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: Constants.API.timeout)
        let session: URLSession = URLSession.shared

        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in

            guard error == nil else {
                print("Error > \(String(describing: error?.localizedDescription))" as Any)
                session.invalidateAndCancel()
                taskCallback(false, error, nil)
                return
            }
            guard data != nil else {
                session.invalidateAndCancel()
                taskCallback(false, nil, nil) // data is always non-nil.
                return
            }

            if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
                taskCallback(true, nil, data)
            } else {
                session.invalidateAndCancel()
                taskCallback(false, nil, nil)
            }

        })
        task.resume()
    }


}
