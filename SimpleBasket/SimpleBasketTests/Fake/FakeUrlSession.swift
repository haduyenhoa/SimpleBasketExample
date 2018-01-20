//
//  FakeUrlSession.swift
//  SimpleBasketTests
//
//  Created by Duyen Hoa Ha on 20.01.18.
//  Copyright © 2018 HDH. All rights reserved.
//

import Foundation

enum FakeResponseType {
    case succeed
    case invalidData
    case invalidStatusCode
    case unauthorized
    case fail
}

class FakeURLSession: URLSession {
    public var responseStatus: FakeResponseType = .succeed
    public var successfulResponse: Any = [:]

    public override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        guard let url = request.url else {
            completionHandler(nil, nil, NSError(domain: "No URL", code: 500, userInfo: nil))
            return FakeURLSessionDataTask()
        }

        switch responseStatus {
        case .succeed:
            completionHandler(successfulResponseData(), HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil), nil)
        case .invalidData:
            completionHandler(invalidResponseData(), HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil), nil)
        case .invalidStatusCode:
            completionHandler(invalidResponseData(), HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil), nil)
        case .unauthorized:
            completionHandler(invalidResponseData(), HTTPURLResponse(url: url, statusCode: 401, httpVersion: nil, headerFields: nil), nil)
        case .fail:
            completionHandler(nil, nil, NSError(domain: "FailedRequest", code: 500, userInfo: nil))
        }
        return FakeURLSessionDataTask()
    }

    private func successfulResponseData() -> Data {
        return try! JSONSerialization.data(withJSONObject: successfulResponse)
    }

    private func invalidResponseData() -> Data {
        return Data(count: 1)
    }
}

internal class FakeURLSessionDataTask: URLSessionDataTask {
    internal override func resume() {}
}
