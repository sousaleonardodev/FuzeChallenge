//

import Foundation

protocol ApiServiceEndpoint {
	var url: String { get }
	var queryItems: [URLQueryItem] { get }
}
