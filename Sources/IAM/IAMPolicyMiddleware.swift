import Vapor

public final class IAMPolicyMiddleware<P>: Middleware where P: IAMPolicyAllowable {
    
    private let allowedPolicies:[String]
    
    init(allowed policies: [String]) {
        self.allowedPolicies = policies
    }
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
        let config = try request.make(IAMConfig.self)
        let hostname = config.hostname
        let port = config.port
        let checkPath = config.checkPath
        let allowed = allowedPolicies
        let isInException = config.exceptionPaths.contains(request.http.url.path)
        
        guard !isInException else {
            return try next.respond(to: request)
        }
        
        let url = hostname + ":\(port)\(checkPath)"
        let httpReq = HTTPRequest(method: .GET,
                                  url: url,
                                  headers: request.http.headers)
        let req = Request(http: httpReq, using: request)
        
        return try request.client()
            .send(req)
            .flatMap { res in
                switch res.http.status {
                case .ok:
                    return try res.content.decode(IAMResult.self)
                        .flatMap { result in
                            let a = result.policies.filter () { allowed.contains($0) }
                            if (a.count > 0){ return try next.respond(to: request) }
                            else {throw Abort(.unauthorized)}
                    }
                    
                default:
                    throw Abort(.unauthorized)
                }
        }
    }
}

public protocol IAMPolicyAllowable {}

extension IAMPolicyAllowable {
    public static func IAMAuthPolicyMiddleware(allowed policies: [String]) -> IAMPolicyMiddleware<Self> {
        return IAMPolicyMiddleware(allowed: policies)
    }
}


struct IAMResult: Codable {
    let id: Int
    let roles: [String]
    let groups: [String]
    let policies: [String]
}
