import Foundation

@objc(CDVFetchAPI)
class CDVFetchAPI : CDVPlugin {
    @objc(fetch:)
    func fetch(command: CDVInvokedUrlCommand) {
        let urlString = command.argument(at: 0) as? String ?? ""
        let method = command.argument(at: 1)
        let headers = command.argument(at: 2)
        let body = command.argument(at: 3)

        guard let url = URL(string: urlString) else {
            let result = CDVPluginResult(
                status: CDVCommandStatus_ERROR,
                messageAs: [
                    "error": "Invalid URL"
                ]
            )

            self.commandDelegate.send(result, callbackId: command.callbackId)

            return
        }

        var request = URLRequest(url: url)

        if let method = method as? String {
            request.httpMethod = method
        }

        if let headers = headers as? [[String]] {
            for header in headers {
                if header.count == 2 {
                    request.addValue(header[1], forHTTPHeaderField: header[0])
                }
            }
        }

        switch body {
        case let body as String:
            request.httpBody = body.data(using: String.Encoding.utf8)
        case let body as Data:
            request.httpBody = body
        default:
            break
        }

        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)

        let task = session.dataTask(with: request) { data, response, error in
            if let data = data, let response = response as? HTTPURLResponse {
                let result = CDVPluginResult(
                    status: CDVCommandStatus_OK,
                    messageAsMultipart: [
                        data,
                        [
                            "headers": response.allHeaderFields,
                            "status": response.statusCode,
                            "statusText": HTTPURLResponse.localizedString(forStatusCode: response.statusCode),
                            "url": response.url?.absoluteString ?? ""
                        ]
                    ]
                )

                self.commandDelegate.send(result, callbackId: command.callbackId)
            } else {
                let result = CDVPluginResult(
                    status: CDVCommandStatus_ERROR,
                    messageAs: [
                        "error": error?.localizedDescription ?? "No data in response"
                    ]
                )

                self.commandDelegate.send(result, callbackId: command.callbackId)
            }
        }

        task.resume()
    }
}
