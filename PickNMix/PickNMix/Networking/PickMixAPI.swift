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

class PickMixAPI {

    static func checkDBAndMakeRequest() {
        // Check DB before we do any request
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

            let decoder = JSONDecoder()
            do {

                let model = try decoder.decode(Root.self, from: dataResponse)
//                print(model.industries)
//                print(model.triggers)
//                print(model.businessModels)

                self.writeToDB(model: model)

                /*
                 // Old parsing code
                let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: [])

                old_parse(jsonResponse: jsonResponse, { (success, error) in
                    if (error != nil) {
                        print ("error >>")
                        print (error?.localizedDescription as Any)
                    }
                })
                 */
            }
            catch let parsingError {
                print("Error", parsingError)
            }
        }
    }

    private static func writeToDB(model: Root) {

        let realm = try! Realm()
        let ind = realm.objects(IndustryEntity.self)
        print(ind)

        model.industries.forEach({ (entry: String) in
            print("writing: \(entry)")

            DispatchQueue(label: "background").async {
                autoreleasepool {
                    let realm = try! Realm()
                    realm.beginWrite()

                    model.industries.forEach({ (entry: String) in
                        let myIndustry = IndustryEntity()
                        myIndustry.name = entry
                        print(myIndustry.name)
                    })

                    print("committing")
                    try? realm.commitWrite()
                }
            }
        })


//
//        // Query and update from any thread
//        DispatchQueue(label: "background").async {
//            autoreleasepool {
//                let realm = try! Realm()
//                realm.beginWrite()
//
//                model.industries.forEach({ (entry: String) in
//                    let myIndustry = IndustryEntity()
//                    myIndustry.name = entry
//                    print(myIndustry.name)
//                })
//
//                try? realm.commitWrite()
//            }
//        }


    }


    // Here for posterity (not used)
    private static func old_parse(jsonResponse: Any, _ taskCallback: @escaping (Bool, Error?) -> ()) {
        guard let jsonArray = jsonResponse as? [String: Any] else {
            let error = NSError(domain: "Can't find JSON", code: 0, userInfo: nil)
            taskCallback(false, error)
            return
        }

        guard let industryList = jsonArray["industries"] as? [String] else {
            print ("Cannot find industries")
            let error = NSError(domain: "Can't find industries", code: 0, userInfo: nil)
            taskCallback(false, error)
            return
        }
        guard let triggerList = jsonArray["triggers"] as? [String] else {
            let error = NSError(domain: "Can't find triggers", code: 0, userInfo: nil)
            taskCallback(false, error)
            return
        }
        guard let businessList = jsonArray["businessModels"] as? [Array<String>] else {
            let error = NSError(domain: "Can't find bmodels", code: 0, userInfo: nil)
            taskCallback(false, error)
            return
        }

        print (industryList)
        print (triggerList)
        print (businessList)
        print ("--------")
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
