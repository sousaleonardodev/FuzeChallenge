//

import Foundation

struct MatchPlayerModel: Decodable {
	let name: String
	let lastName: String
	let nickname: String
	let photo: URL?
	let teamId: Int

	private enum RootKeys: String, CodingKey {
		case name = "first_name"
		case lastName = "last_name"
		case nickname = "name"
		case photo = "image_url"
		case team = "current_team"
	}

	private enum TeamKeys: String, CodingKey {
		case id
	}

	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: RootKeys.self)
		self.name = try container.decode(String.self, forKey: .name)
		self.lastName = try container.decode(String.self, forKey: .lastName)
		self.nickname = try container.decode(String.self, forKey: .nickname)
		self.photo = try container.decodeIfPresent(URL.self, forKey: .photo)

		let teamContainer = try container.nestedContainer(keyedBy: TeamKeys.self, forKey: .team)
		self.teamId = try teamContainer.decode(Int.self, forKey: .id)
	}
}
