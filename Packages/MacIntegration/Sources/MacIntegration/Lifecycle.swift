import AppKit

public enum LifecycleEvent: Sendable {
    case willSleep, didWake, sessionResigned, sessionActivated
}

@MainActor
public protocol LifecycleObserving: AnyObject {
    func start(_ receive: @escaping @MainActor @Sendable (LifecycleEvent) -> Void)
    func stop()
}

/// Supported workspace signals only. Display sleep is deliberately not treated as screen lock.
@MainActor
public final class WorkspaceLifecycleObserver: NSObject, LifecycleObserving {
    private var receive: (@MainActor @Sendable (LifecycleEvent) -> Void)?

    public override init() { super.init() }

    public func start(_ receive: @escaping @MainActor @Sendable (LifecycleEvent) -> Void) {
        stop()
        self.receive = receive
        let center = NSWorkspace.shared.notificationCenter
        center.addObserver(
            self, selector: #selector(willSleep), name: NSWorkspace.willSleepNotification,
            object: nil)
        center.addObserver(
            self, selector: #selector(didWake), name: NSWorkspace.didWakeNotification, object: nil)
        center.addObserver(
            self, selector: #selector(sessionResigned),
            name: NSWorkspace.sessionDidResignActiveNotification, object: nil)
        center.addObserver(
            self, selector: #selector(sessionActivated),
            name: NSWorkspace.sessionDidBecomeActiveNotification, object: nil)
    }

    public func stop() {
        NSWorkspace.shared.notificationCenter.removeObserver(self)
        receive = nil
    }

    @objc private func willSleep() { receive?(.willSleep) }
    @objc private func didWake() { receive?(.didWake) }
    @objc private func sessionResigned() { receive?(.sessionResigned) }
    @objc private func sessionActivated() { receive?(.sessionActivated) }
}
