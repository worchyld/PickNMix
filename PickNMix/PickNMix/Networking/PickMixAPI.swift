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

    static func getData(_ completion: @escaping (Bool, Error?, RootEntity?) -> ()) {

        // Check DB before we do any request
        let rootEntity = RootEntity()
        guard let industries = rootEntity.industries else {
            let error = NSError.init(domain: "No DB found", code: 0, userInfo: nil)
            completion(false, error as Error, nil)
            return
        }

        if (industries.count == 0) {

            var returnError: Error?

            // Move to a background thread to do some long running work
            DispatchQueue.global(qos: .background).async {

                self.makeRequest { (success, error) in
                    if (success == false || error != nil) {
                        print (error?.localizedDescription as Any)
                        returnError = error
                    }
                    else {
                        print ("-- Completed: write --")
                    }
                }

                // Bounce back to the main thread to update the UI
                DispatchQueue.main.async {
                    autoreleasepool {

                        var success = false
                        if (returnError != nil) {
                            success = true
                        }
                        completion(success, returnError, rootEntity)

                    }
                }
            }
        }
        else {
            completion(true, nil, rootEntity)
        }
    }

    static func makeRequest(_ completion: @escaping (Bool, Error?) -> ()) {

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

                let model = try decoder.decode(RootModel.self, from: dataResponse)

                self.writeToDB(model: model, completion: {
                    completion(true, nil)
                })
            }
            catch let parsingError {
                print("Error", parsingError)
            }
        }
    }

    private static func writeToDB(model: RootModel, completion: @escaping () -> Void) {

        // Prepare realm objects for DB
        let objectsIndustryList = List<IndustryEntity>()
        let objectsBusinessList = List<BusinessEntity>()
        let objectsTriggerList = List<TriggerEntity>()

        model.industries.forEach { (entry: String) in
            let object = IndustryEntity()
            object.name = entry

            objectsIndustryList.append(object)
        }

        model.triggers.forEach { (entry: String) in
            let object = TriggerEntity()
            object.name = entry

            objectsTriggerList.append(object)
        }

        let bmodels = model.businessModelsFlattened
        bmodels.forEach { (entry: String) in
            let object = BusinessEntity()
            object.name = entry

            objectsBusinessList.append(object)
        }

        // Write objects to Realm DB
        DispatchQueue(label: "background").async {
            autoreleasepool {
                let realm = try! Realm()
                realm.beginWrite()
                realm.add(objectsIndustryList)
                realm.add(objectsTriggerList)
                realm.add(objectsBusinessList)
                try! realm.commitWrite()

                completion()
            }
        }


    }
}

// MARK: - RequestURL

extension PickMixAPI {

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


extension PickMixAPI {
    
    // Here for posterity (not used)
    private static func old_parse(jsonResponse: Any, _ taskCallback: @escaping (Bool, Error?) -> ()) {
        guard let jsonArray = jsonResponse as? [String: Any] else {
            let error = NSError(domain: "Can't find JSON", code: 0, userInfo: nil)
            taskCallback(false, error)
            return
        }

        guard let industryList = jsonArray["industries"] as? [String] else {
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
}
