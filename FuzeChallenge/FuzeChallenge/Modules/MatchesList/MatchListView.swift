//

import SwiftUI

struct MatchView: View {
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
					.font(.system(size: 12.0))
					.foregroundStyle(Color(white: 1.0, opacity: 0.5))
				Spacer(minLength: 20)
				TeamView(viewModel: viewModel.secondOpponent)
				Spacer()
			}
			Divider()
				.background(Color(white: 1, opacity: 0.2))
			HStack() {
				LeagueInfoView(leagueName: viewModel.leagueSerie, leagueImageURL: viewModel.leagueImage)
				Spacer()
			}
		}
		.background(Color(red: 39/255, green: 38/255, blue: 57/255))
		.cornerRadius(16)
		.listRowBackground(Color.clear)
	}
}

struct LeagueInfoView: View {
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
				.font(.system(size: 8))
				.foregroundStyle(.white)
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
			//TODO: Increase font size
				.font(Font.system(size: 10, weight: .medium))
				.foregroundStyle(.white)
		}
		.padding(.init(top: 18.5, leading: 0, bottom: 18.5, trailing: 0))
	}
}

struct MatchStatusView: View {
	private let status: String

	init(status: String) {
		self.status = status
	}

	var body: some View {
		Text(status)
			.font(Font.system(size: 12, weight: .medium))
			.foregroundColor(.white)
			.padding(.horizontal, 8)
			.padding(.vertical, 8)
			.background(Color.redAlert)
			.clipShape(.rect(
				topLeadingRadius: 0,
				bottomLeadingRadius: 16,
				bottomTrailingRadius: 0,
				topTrailingRadius: 16
			))
	}
}

#Preview {
	MatchStatusView(status: "AGORA")
}

struct MatchListView: View {
	@ObservedObject var viewModel: MatchListViewModel

	var body: some View {
		NavigationStack {
			List(viewModel.datasource) { viewModel in
				MatchView(viewModel: viewModel)
					.listRowSeparator(.hidden)
			}
			.listRowBackground(Color.red)
			.background(Color.darkPurple)
			.listRowSpacing(12)
			.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
			.listStyle(.plain)
			.refreshable {
				viewModel.fetchMatches()
			}
			.navigationTitle(Text("Partidas"))
		}
	}

	init(viewModel: MatchListViewModel) {
		self.viewModel = viewModel
	}
}
