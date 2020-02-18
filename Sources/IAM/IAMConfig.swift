public class IAMConfig {
    let hostname: String
    let port: Int
    let exceptionPaths: [String]
    let checkPath: String
    
    public init(hostname: String,
                port: Int = 8080,
                exceptionPaths: [String] = [],
                checkPath: String = "/v1/identity/check" ) {
        self.hostname = hostname
        self.port = port
        self.exceptionPaths = exceptionPaths
        self.checkPath = checkPath
    }
}
