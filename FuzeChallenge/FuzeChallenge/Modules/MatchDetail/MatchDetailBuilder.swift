//

import SwiftUI

struct MatchDetailBuilder {
	static func build() -> some View {
		let apiService = ApiService(session: URLSession.shared)
		let detailService = MatchDetailService(apiService: apiService)
		let viewModel = MatchDetailViewModel(service: detailService)
		
		return MatchDetailView(viewModel: viewModel)
	}
}
