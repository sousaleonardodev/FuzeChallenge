//

import SwiftUI

struct MatchView: View {
	@EnvironmentObject private var themeManager: ThemeManager
	private var viewModel: MatchViewModel

	init(viewModel: MatchViewModel) {
		self.viewModel = viewModel
	}

	var body: some View {
		VStack(alignment: .center, spacing: 0) {
			HStack() {
				Spacer()
				MatchStatusView(status: viewModel.matchStatus)
			}
			HStack(alignment: .center) {
				Spacer()
				TeamView(viewModel: viewModel.firstOpponent)
				Spacer(minLength: 20)
				Text("VS")
					.font(themeManager.currentTheme.fontMedium)
					.foregroundStyle(themeManager.currentTheme.lightGray)
				Spacer(minLength: 20)
				TeamView(viewModel: viewModel.secondOpponent)
				Spacer()
			}
			Divider()
			//TODO: Check height
				.frame(height: 1)
				.padding(.horizontal)
				.background(themeManager.currentTheme.lightGray)
			HStack() {
				LeagueInfoView(leagueName: viewModel.leagueSerie, leagueImageURL: viewModel.leagueImage)
				Spacer()
			}
		}
		.background(themeManager.currentTheme.primary)
		.cornerRadius(16)
		.listRowBackground(themeManager.currentTheme.background)
	}
}

struct LeagueInfoView: View {
	@EnvironmentObject private var themeManager: ThemeManager
	private let leagueName: String
	private let leagueImageURL: URL?

	init(leagueName: String, leagueImageURL: URL?) {
		self.leagueName = leagueName
		self.leagueImageURL = leagueImageURL
	}

	var body: some View {
		HStack(alignment: .center, spacing: 8) {
			AsyncImage(url: leagueImageURL) { phase in
				switch phase {
				case .empty:
					EmptyView()
				case .failure:
					Text("Error loading image")
				case .success(let image):
					image.resizable()
				default:
					ProgressView()
				}
			}
			.clipShape(.circle)
			.frame(width: 16, height: 16)
			Text(leagueName)
				.font(themeManager.currentTheme.fontSmallest)
				.foregroundStyle(themeManager.currentTheme.textPrimary)
		}
		.padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
	}
}

#Preview {
	LeagueInfoView(leagueName: "Gamers Club Liga Série A",
				   leagueImageURL: URL(string: "https://cdn.pandascore.co/images/league/image/4554/Liga_Gamers_Club_SSrie_A_logo.png")
	)
	.background(Color.blue)
}

struct TeamView: View {
	@EnvironmentObject private var themeManager: ThemeManager
	private let viewModel: TeamViewModel

	init(viewModel: TeamViewModel) {
		self.viewModel = viewModel
	}

	var body: some View {
		VStack(alignment: .center, spacing: 10) {
			AsyncImage(url: viewModel.image) { phase in
				switch phase {
				case .empty:
					EmptyView()
				case .failure:
					Text("Error loading image")
				case .success(let image):
					image.resizable()
				default:
					ProgressView()
				}
			}
			.frame(width: 60, height: 80)
			Text(viewModel.name)
				.lineLimit(2)
				.font(themeManager.currentTheme.fontSmall)
				.foregroundStyle(.white)
		}
		.padding(.init(top: 18.5, leading: 0, bottom: 18.5, trailing: 0))
	}
}

struct MatchStatusView: View {
	@EnvironmentObject private var themeManager: ThemeManager
	private let status: String

	init(status: String) {
		self.status = status
	}

	var body: some View {
		Text(status)
			.font(themeManager.currentTheme.fontMedium)
			.foregroundColor(themeManager.currentTheme.textPrimary)
			.padding(.horizontal, 8)
			.padding(.vertical, 8)
			.background(themeManager.currentTheme.background)
			.clipShape(
				.rect(
					topLeadingRadius: 0,
					bottomLeadingRadius: 16,
					bottomTrailingRadius: 0,
					topTrailingRadius: 16
				)
			)
	}
}

#Preview {
	MatchStatusView(status: "AGORA")
}

struct LoadingView: View {
	@EnvironmentObject private var themeManager: ThemeManager

	var body: some View {
		ZStack {
			themeManager.currentTheme.background
				.ignoresSafeArea()
			ProgressView()
				.scaleEffect(2)
				.tint(themeManager.currentTheme.textPrimary)
		}
	}
}

struct MatchListView: View {
	@EnvironmentObject private var themeManager: ThemeManager
	@ObservedObject var viewModel: MatchListViewModel

	var body: some View {
		NavigationStack {
			List(viewModel.datasource) { viewModel in
				MatchView(viewModel: viewModel)
					.listRowSeparator(.hidden)
			}
			.listRowSpacing(12)
			.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
			.listStyle(.plain)
			.refreshable {
				viewModel.fetchMatches()
			}
			.modifier(NavigationBarModifier(themeManager))
			.navigationTitle("Partidas")
			.environmentObject(themeManager)
		}
	}

	init(viewModel: MatchListViewModel) {
		self.viewModel = viewModel
	}
}

struct NavigationBarModifier: ViewModifier {
	private let themeManager: ThemeManager

	init(_ themeManager: ThemeManager) {
		self.themeManager = themeManager

		let appearance = UINavigationBarAppearance()
		appearance.configureWithOpaqueBackground()
		appearance.backgroundColor = UIColor(themeManager.currentTheme.background)

		appearance.titleTextAttributes = [
			.foregroundColor: UIColor(themeManager.currentTheme.textPrimary),
			.font: themeManager.currentTheme.fontNavigationTitleSmall
		]

		appearance.largeTitleTextAttributes = [
			.foregroundColor: UIColor(themeManager.currentTheme.textPrimary),
			.font: themeManager.currentTheme.fontNavigationTitle
		]

		UINavigationBar.appearance().standardAppearance = appearance
		UINavigationBar.appearance().compactAppearance = appearance
		UINavigationBar.appearance().scrollEdgeAppearance = appearance
	}

	func body(content: Content) -> some View {
		content
			.background(themeManager.currentTheme.background)
			.navigationBarTitleDisplayMode(.automatic)
	}
}
