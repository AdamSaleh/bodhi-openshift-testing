{ Type =
    { apiVersion : Text
    , kind : Text
    , metadata : { labels : { app : Text, service : Text }, name : Text }
    , spec : (./service.openshift.io.v1.ServiceSpec.dhall).Type
    }
, default = { apiVersion = "v1", kind = "Service" }
}
