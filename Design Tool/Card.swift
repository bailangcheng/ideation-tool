// Card.swift
import Foundation

// Base CardType Enumeration
enum CardType {
    case object
    case material
    case degradation
    case vocabulary
}

// AnyCard Enumeration to encapsulate all card types
enum AnyCard: Identifiable, Equatable {
    case object(ObjectCard)
    case material(MaterialCard)
    case degradation(DegradationCard)
    case vocabulary(VocabularyCard)
    
    var id: UUID {
        switch self {
        case .object(let card):
            return card.id
        case .material(let card):
            return card.id
        case .degradation(let card):
            return card.id
        case .vocabulary(let card):
            return card.id
        }
    }
}

// ObjectCard Struct
struct ObjectCard: Identifiable, Codable, Equatable {
    let id = UUID()
    let name: String
    let categories: [String]
    let image: String
}

// MaterialCard Struct
struct MaterialCard: Identifiable, Codable, Equatable {
    let id = UUID()
    let name: String
    let type: [String]
    let source: [String]
    let properties: String
    let degradation_methods: [DegradationMethod]
    let degradation_description: String
    let applications: String
    let decomposition_time: String
    let image: String
}

struct DegradationMethod: Identifiable, Codable, Equatable {
    let id = UUID()
    let name: String
    let image: String
}

// DegradationCard Struct
struct DegradationCard: Identifiable, Codable, Equatable {
    let id = UUID()
    let name: String
    let description: String
    let design_insights: String
    let images: [String]
}

// VocabularyCard Struct
struct VocabularyCard: Identifiable, Codable, Equatable {
    let id = UUID()
    let name: String
    let description: String
    let design_insight: String
    let image: String
}


//// Card.swift
//import Foundation
//
//// Base CardType Enumeration
//enum CardType {
//    case object
//    case material
//    case degradation
//    case vocabulary
//}
//
//// AnyCard Enumeration to encapsulate all card types
//enum AnyCard: Identifiable, Equatable {
//    case object(ObjectCard)
//    case material(MaterialCard)
//    case degradation(DegradationCard)
//    case vocabulary(VocabularyCard)
//    
//    var id: UUID {
//        switch self {
//        case .object(let card):
//            return card.id
//        case .material(let card):
//            return card.id
//        case .degradation(let card):
//            return card.id
//        case .vocabulary(let card):
//            return card.id
//        }
//    }
//}
//
//// ObjectCard Struct
//struct ObjectCard: Identifiable, Codable, Equatable {
//    let id = UUID()
//    let name: String
//    let categories: [String]
//    let image: String
//}
//
//// MaterialCard Struct
//struct MaterialCard: Identifiable, Codable, Equatable {
//    let id = UUID()
//    let name: String
//    let type: [String]
//    let source: [String]
//    let properties: String
//    let degradation_methods: [DegradationMethod]
//    let degradation_description: String
//    let applications: String
//    let decomposition_time: String
//    let image: String
//}
//
//struct DegradationMethod: Identifiable, Codable, Equatable {
//    let id = UUID()
//    let name: String
//    let image: String
//}
//
//// DegradationCard Struct
//struct DegradationCard: Identifiable, Codable, Equatable {
//    let id = UUID()
//    let name: String
//    let description: String
//    let design_insights: String
//    let image: String
//}
//
//// VocabularyCard Struct
//struct VocabularyCard: Identifiable, Codable, Equatable {
//    let id = UUID()
//    let name: String
//    let description: String
//    let design_insight: String
//    let image: String
//}
