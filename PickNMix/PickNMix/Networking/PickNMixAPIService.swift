import Foundation

enum PickNMixAPI: HTTPWebService, Equatable {

    case ideas()

    var base: String  {

        return "http://concepting.foundersfactory.com/demo/"
    }

    var endpoint: String {

        switch self {

        case .ideas():
            return "idea-generator/"
        }
    }

    var method: String {

        switch self {

        case .ideas:
            return "GET"
        }
    }
}
