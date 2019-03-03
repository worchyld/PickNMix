//
//  PickMixAPI.swift
//  PickNMix
//
//  Created by Amarjit on 02/03/2019.
//  Copyright © 2019 Amarjit. All rights reserved.
//

import Foundation
import RealmSwift

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

class DatabaseManager {

    public static func getBusinessEntities() -> Results<IndustryEntity>? {
        let realm = try! Realm()
        let industries = realm.objects(IndustryEntity.self)
        return industries
    }
}

class PickMixAPI {

    static func checkDBAndMakeRequest() {
        // Check DB before we do any request
        // We know the API never changes.
        guard let industries = DatabaseManager.getBusinessEntities() else {
            print ("There are no industries on DB")
            return
        }
        print ("There are \(industries.count) industries in DB")
    }

    static func makeRequest() {
        guard let requestURL = Constants.API.url else {
            print ("No url")
            return
        }

        self.executeRequestURL(requestURL) { (success, error, data) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }

            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: [])

                parse(jsonResponse: jsonResponse)

//                let decoder = JSONDecoder()
//                let model = try decoder.decode(Industry.self, from: dataResponse) //Decode JSON Response Data
//                print(model.name)
            }
            catch let parsingError {
                print("Error", parsingError)
            }
        }
    }

    private static func parse(jsonResponse: Any) {

        guard let jsonArray = jsonResponse as? [String: Any] else {
            return
        }

        guard let industries = jsonArray["industries"] as? [String] else {
            print ("Cannot find industries")
            return
        }
        guard let triggers = jsonArray["triggers"] as? [String] else {
            print ("Cannot find triggers")
            return
        }
        guard let bmodels = jsonArray["businessModels"] as? [Array<String>] else {
            print ("Cannot find bmodels")
            return
        }

        print (industries)
        print (triggers)
        //print (bmodels)

        for item in bmodels {
            print (item)
        }

    }


    // lightweight request URL
    private static func executeRequestURL(_ requestURL: URL, taskCallback: @escaping (Bool, Error?, Data?) -> ()) {
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
