//

import Foundation
import SwiftUI

struct MatchDetailView: View {
	@EnvironmentObject var themeManager: ThemeManager
	@ObservedObject private var viewModel: MatchDetailViewModel

	init(viewModel: MatchDetailViewModel) {
		self.viewModel = viewModel
	}

	var body: some View {
		switch viewModel.state {
		case .loading:
			LoadingView()
		case .error(let error):
			ErrorView(message: error.localizedDescription) {
				viewModel.loadDetails()
			}
		case .loaded:
				VStack(alignment: .center, spacing: 12) {
					HStack(spacing: 20) {
						if let firstTeam = viewModel.firstTeam,
						   let secondTeam = viewModel.secondTeam {
							TeamView(viewModel: firstTeam)
							Text("VS")
								.font(themeManager.currentTheme.fontSmall)
								.foregroundStyle(themeManager.currentTheme.lightGray)
							TeamView(viewModel: secondTeam)
						}
					}
					Text(viewModel.status)
						.font(themeManager.currentTheme.fontMediumBold)
						.foregroundStyle(themeManager.currentTheme.textPrimary)

					List {
						ForEach(0..<viewModel.dataSource.count) { i in
							HStack(alignment: .center, spacing: 13) {

							}
						}
					}.listStyle(PlainListStyle())
				}
				.navigationTitle(viewModel.leagueName)
				.navigationBarTitleDisplayMode(.inline)
				.background(themeManager.currentTheme.background)
		}
	}
}
	
	var body: some View {
		LoadingView().task { self.viewModel.loadDetails()
		}
	}
}
