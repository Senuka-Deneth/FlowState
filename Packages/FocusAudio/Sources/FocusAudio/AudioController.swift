import FocusDomain

public enum AudioState: Equatable, Sendable {
    case stopped, loading, playing, paused, failed
}

public enum AudioError: Error {
    case engineNotImplemented
}

/// A control-plane boundary. No audio callback or real-time DSP runs in this scaffold.
public protocol AudioControlling: Sendable {
    func prepare(tuning: FocusTuning) async throws
    func stop() async
}

public actor UnavailableAudioController: AudioControlling {
    public init() {}
    public func prepare(tuning: FocusTuning) throws { throw AudioError.engineNotImplemented }
    public func stop() {}
}
