{ apiVersion : Text
, kind : Text
, metadata : { labels : { app : Text }, name : Text }
, spec :
    { host : Text
    , port : { targetPort : Text }
    , tls : { insecureEdgeTerminationPolicy : Text, termination : Text }
    , to : { kind : Text, name : Text, weight : Natural }
    , wildcardPolicy : Optional Text
    }
}
