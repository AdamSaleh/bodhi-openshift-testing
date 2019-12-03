{ Type =
    { apiVersion : Text
    , kind : Text
    , metadata : { labels : { app : Text, service : Text }, name : Text }
    , spec :
        { host : Text
        , port : { targetPort : Text }
        , tls : { termination : Text }
        , to : { kind : Text, name : Text, weight : Natural }
        , wildcardPolicy : Optional Text
        }
    }
, default = { apiVersion = "route.openshift.io/v1", kind = "Route" }
}
