import Vapor

public struct IAMConfigFactory {
    var make: ((Request) -> IAMConfig)?
    
    mutating public func use(_ make: @escaping ((Request) -> IAMConfig)) {
        self.make = make
    }
}

extension Application {
    private struct IAMConfigFactoryKey: StorageKey {
        typealias Value = IAMConfigFactory
    }
    
    public var IAMConfigFactory: IAMConfigFactory {
        get {
            self.storage[IAMConfigFactoryKey.self] ?? .init()
        }
        set {
            self.storage[IAMConfigFactoryKey.self] = newValue
        }
    }
}

extension Request {
    public var IAMConfig: IAMConfig {
        application.IAMConfigFactory.make!(self)
    }
}
