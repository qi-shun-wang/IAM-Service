import Vapor

public final class IAMPolicyMiddleware<P>: Middleware where P: IAMPolicyAllowable {
    
    public func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        let config = request.IAMConfig
        guard config.isEnable else {return next.respond(to: request)}
        let hostname = config.hostname
        let port = config.port
        let checkPath = config.checkPath
        let allowed = allowedPolicies
        
        let isInException = config.exceptionPaths.contains(request.url.path)
        
        guard !isInException else {
            return next.respond(to: request)
        }
        
        let url = hostname + ":\(port)\(checkPath)"
        
        
        guard let token = request.headers.bearerAuthorization?.token
        else { return request.eventLoop.future(Response(status: .unauthorized))}
        
        let headers = HTTPHeaders([(HTTPHeaders.Name.authorization.description, "Bearer \(token)")])
        return request
            .client
            .get(URI(string: url), headers: headers)
            .flatMap({ (res) -> EventLoopFuture<Response> in
                switch res.status {
                case .ok:
                    do {
                        let result = try res.content.decode(IAMResult.self)
                        let a = result.policies.filter () { allowed.contains($0) }
                        if (a.count > 0){ return next.respond(to: request) }
                        else {throw Abort(.unauthorized)}
                    } catch let error {
                        return request.eventLoop.future(Response(status: .internalServerError,
                                                                  body: Response.Body(string: error.localizedDescription)))
                    }
                default:
                    return request.eventLoop.future(Response(status: .unauthorized))
                }
            })
    }
    
    private let allowedPolicies:[String]
    
    init(allowed policies: [String]) {
        self.allowedPolicies = policies
    }
    
}

public protocol IAMPolicyAllowable {}

extension IAMPolicyAllowable {
    public static func IAMAuthPolicyMiddleware(allowed policies: [String]) -> IAMPolicyMiddleware<Self> {
        return IAMPolicyMiddleware(allowed: policies)
    }
}


struct IAMResult: Codable {
    let id: String
    let roles: [String]
    let groups: [String]
    let policies: [String]
}
