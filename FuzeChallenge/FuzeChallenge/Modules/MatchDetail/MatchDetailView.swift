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
		LoadingView().task { self.viewModel.loadDetails()
		}
	}
}
