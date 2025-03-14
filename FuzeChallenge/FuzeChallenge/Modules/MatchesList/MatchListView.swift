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
