let RollingParams = ./apps.openshift.io.RollingParams.dhall
in
{ Type  = (./apps.openshift.v1.io.Strategy.dhall).Type
, default = { activeDeadlineSeconds = 21600
    , recreateParams = 
      { timeoutSeconds = 600 
      , post = None { execNewPod : { command : List Text }
          , containerName : Text
          , failurePolicy : Text
          }
      }
    , resources = {=}
    , rollingParams = Some RollingParams.default
    , type = "Rolling"
    }
}
