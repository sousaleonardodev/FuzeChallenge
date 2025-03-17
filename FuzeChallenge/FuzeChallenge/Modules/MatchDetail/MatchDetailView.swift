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
				Spacer()
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

				Spacer()
				List {
					ForEach(0..<viewModel.dataSource.count) { i in
						HStack(alignment: .center, spacing: 13) {
							MatchPlayerView(viewModel: viewModel.dataSource[i], isAlingLeading: true)

							if viewModel.secondTeamPlayers.count > i {
								MatchPlayerView(viewModel: viewModel.secondTeamPlayers[i], isAlingLeading: false)
							} else {
								Spacer(minLength: 192)
							}
						}
						.listRowSeparator(.hidden)
						.background(themeManager.currentTheme.background)
						.listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
					}
				}
				.offset(y: 10)
				.listRowSpacing(12)
				.listStyle(PlainListStyle())
				.listRowBackground(themeManager.currentTheme.background)
			}
			.navigationTitle(viewModel.leagueName)
			.navigationBarTitleDisplayMode(.inline)
			.background(themeManager.currentTheme.background)
		}
	}
}

struct MatchPlayerView: View {
	@EnvironmentObject var themeManager: ThemeManager
	private let viewModel: MatchPlayerViewModel
	private let isAlingLeading: Bool

	init(viewModel: MatchPlayerViewModel, isAlingLeading: Bool) {
		self.viewModel = viewModel
		self.isAlingLeading = isAlingLeading
	}

	var body: some View {
		VStack(alignment: .trailing) {
			ZStack {
				themeManager.currentTheme.primary
					.clipShape(.rect(
						topLeadingRadius:  !isAlingLeading ? 12 : 0,
						bottomLeadingRadius:  !isAlingLeading ? 12 : 0,
						bottomTrailingRadius: isAlingLeading ? 12 : 0,
						topTrailingRadius:  isAlingLeading ? 12 : 0
					))

				HStack(alignment: .center, spacing: 16) {
					if isAlingLeading {
						Spacer()
						nameView
						photoView
					} else {
						photoView
						nameView
						Spacer()
					}

				}
			}
		}
	}

	var photoView: some View {
		let offset: CGFloat = isAlingLeading ? -10 : 10

		return AsyncImage(url: viewModel.photo,
				   transaction: Transaction(animation: .default)) { phase in
			switch phase {
			case .empty, .failure:
				Image(.player)
					.foregroundStyle(themeManager.currentTheme.lightGray)
					.frame(width: 48, height: 48)
					.clipShape(.rect(cornerRadius: 8))
			case .success(let image):
				image
					.resizable()
					.foregroundStyle(themeManager.currentTheme.lightGray)
					.frame(width: 48, height: 48)
					.clipShape(.rect(cornerRadius: 8))
			default:
				ProgressView()
					.tint(themeManager.currentTheme.textPrimary)
			}
		}.offset(x: offset, y: -8)
	}

	var nameView: some View {
		VStack(alignment: isAlingLeading ? .trailing : .leading, spacing: 8) {
			Spacer()
			Text(viewModel.nickname)
				.foregroundStyle(themeManager.currentTheme.textPrimary)
				.font(themeManager.currentTheme.fontBig)
			Text(viewModel.name)
				.foregroundStyle(themeManager.currentTheme.textSecondary)
				.font(themeManager.currentTheme.fontMedium)
		}
	}
}
