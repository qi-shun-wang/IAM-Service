
## Usage   
#### Register IAMConfig (in configure.swift)

    let exceptionPaths = ["/v1/identity/check","/v1/identity/token"]
    let hostname = "http://localhost"
    let port = 8080
    let iamConfig = IAMConfig(hostname: hostname,
                              port: port,
                              exceptionPaths: exceptionPaths)
    services.register(iamConfig)
#### Create extension of allowing IAM policy (User or any object)
    import IAM
    extension User: IAMPolicyAllowable {}
#### Grouped Router with Middleware (in any route collection)
    let allowedPolicy = User.IAMAuthPolicyMiddleware(allowed: ["ROOT"])
    let groups = router.grouped("groups").grouped(allowedPolicy)