//

import SwiftUI

struct MatchDetailBuilder {
	static func build(match: MatchModel) -> some View {
		let apiService = ApiService(session: URLSession.shared)
		let detailService = MatchDetailService(apiService: apiService)
		let viewModel = MatchDetailViewModel(service: detailService, match: match)
		
		return MatchDetailView(viewModel: viewModel)
	}
}
