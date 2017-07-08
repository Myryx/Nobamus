/**
 Ошибка выполенения запроса к API
 
 - noInternetConnection: соединенеие с сервером отсутствует
 - custom:               произвольная ошибка с описанием
 - other:                другая ошибка
 */
import Foundation

enum APIError: Error {
    case noInternetConnection
    case gotNotAnHTTPResponse
    case responseProcessingFailed
    case invalidResponseFormat
    case apiError(String)
    case other
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return localizedStringForKey("No Internet Connection")
        default:
            return localizedStringForKey("Something Went Wrong")
        }
    }
}
