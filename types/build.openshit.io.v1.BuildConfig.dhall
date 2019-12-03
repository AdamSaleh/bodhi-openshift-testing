{ Type =
    { apiVersion : Text
    , kind : Text
    , metadata : { labels : { build : Text }, name : Text }
    , spec : (./build.openshift.v1.io.BuildConfigSpec.dhall).Type
    }
, default =
    { apiVersion = "build.openshift.io/v1"
    , kind = "BuildConfig"
    }
}
