import Foundation

/// The WireGuard server's byte counters. They only grow, so a reader can take the difference of two.
struct TrafficTotals: Equatable {
    var bytesUp: UInt64 = 0
    var bytesDown: UInt64 = 0
}

/// The WireGuard server starts from zero each time the hotspot comes back, while readers expect
/// counters that only grow. This carries what earlier runs counted.
struct CarriedTotals {
    private var carried = TrafficTotals()

    /// Call with a run's last counters when it stops.
    mutating func absorb(_ last: TrafficTotals) {
        carried.bytesUp += last.bytesUp
        carried.bytesDown += last.bytesDown
    }

    func apply(to current: TrafficTotals) -> TrafficTotals {
        TrafficTotals(bytesUp: carried.bytesUp + current.bytesUp, bytesDown: carried.bytesDown + current.bytesDown)
    }
}
