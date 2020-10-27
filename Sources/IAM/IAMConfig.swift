public class IAMConfig {
    let hostname: String
    let port: Int
    let exceptionPaths: [String]
    let checkPath: String
    let isEnable: Bool
    
    public init(hostname: String,
                port: Int = 8080,
                exceptionPaths: [String] = [],
                checkPath: String = "/v1/identity/check" ,
                isEnable: Bool = true) {
        self.hostname = hostname
        self.port = port
        self.exceptionPaths = exceptionPaths
        self.checkPath = checkPath
        self.isEnable = isEnable
    }
}

