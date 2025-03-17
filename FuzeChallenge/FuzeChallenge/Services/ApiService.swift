//

import Combine
import Foundation

protocol ApiServiceProtocol {
	var autorizationToken: String { get }
	func request<T: Decodable>(_ request: ApiServiceEndpoint) -> AnyPublisher<T, RequestError>
}

enum RequestError: Error {
	case network
	case parsing(String)
	case endpointValidation(String)
	case custom(String)
}

class ApiService: ApiServiceProtocol {
	private let session: URLSession
	internal var autorizationToken: String {
		"mXd8AO-tg_mxlncpnTlIqVarlbVK_nwKn888SIxa59Ef2Te2PQ4"
	}

	init(session: URLSession = .shared) {
		self.session = session
	}

	func request<T: Decodable>(_ endpoint: ApiServiceEndpoint) -> AnyPublisher<T, RequestError> {
		guard var request = setupRequest(endpoint) else {
			return Fail(error: .endpointValidation("Invalid URL")).eraseToAnyPublisher()
		}

		request.setValue(autorizationToken, forHTTPHeaderField: "Authorization")
		return session.dataTaskPublisher(for: request)
			.subscribe(on: DispatchQueue.global(qos: .background))
			.tryMap { data, response -> Data in
				guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
					throw RequestError.network
				}
				return data
			}
			.decode(type: T.self, decoder: JSONDecoder())
			.mapError { error in
				.custom(error.localizedDescription)
			}
			.eraseToAnyPublisher()
	}

	private func setupRequest(_ endpoint: ApiServiceEndpoint) -> URLRequest? {
		guard var components = URLComponents(string: endpoint.url) else {
			return nil
		}

		components.queryItems = components.queryItems.map({ $0 + endpoint.queryItems }) ?? endpoint.queryItems

		guard let url = components.url else {
			return nil
		}

		return URLRequest(url: url)
	}
}
