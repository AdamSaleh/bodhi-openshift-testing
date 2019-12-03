{ Type = { apiVersion : Text
          , kind : Text
          , metadata : { labels : { app : Text, service : Text }, name : Text }
          , spec : ((./apps.openshift.io.v1.DeploymentConfigSpec.dhall).Type)
              
          }
, default =  {  apiVersion =
                "apps.openshift.io/v1"
            , kind = "DeploymentConfig"
}
}