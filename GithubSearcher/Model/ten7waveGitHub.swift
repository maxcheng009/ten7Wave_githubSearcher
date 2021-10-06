import Foundation

struct ten7waveGitHub : Codable {

        let incompleteResults : Bool?
        let items : [ten7waveItem]?
        let totalCount : Int?

        enum CodingKeys: String, CodingKey {
                case incompleteResults = "incomplete_results"
                case items = "items"
                case totalCount = "total_count"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                incompleteResults = try values.decodeIfPresent(Bool.self, forKey: .incompleteResults)
                items = try values.decodeIfPresent([ten7waveItem].self, forKey: .items)
                totalCount = try values.decodeIfPresent(Int.self, forKey: .totalCount)
        }

}
