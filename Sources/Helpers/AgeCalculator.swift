import Foundation

struct AgeComponents {
    let years: Int
    let months: Int
    let days: Int
}

struct AgeCalculator {
    static func calculateAge(from birthDate: Date, to currentDate: Date = Date()) -> AgeComponents {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: birthDate, to: currentDate)
        return AgeComponents(
            years: components.year ?? 0,
            months: components.month ?? 0,
            days: components.day ?? 0
        )
    }
}
