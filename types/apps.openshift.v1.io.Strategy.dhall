let RollingParams = ./apps.openshift.io.RollingParams.dhall
in
{ Type  =
{ activeDeadlineSeconds : Natural
, recreateParams :
    { timeoutSeconds : Natural
    , post :
        Optional
          { execNewPod : { command : List Text }
          , containerName : Text
          , failurePolicy : Text
          }
    }
, resources : {}
, rollingParams : Optional RollingParams.Type
, type : Text
}
, default = { activeDeadlineSeconds = 21600
    , recreateParams = 
      { timeoutSeconds = 600 
      , post = None { execNewPod : { command : List Text }
          , containerName : Text
          , failurePolicy : Text
          }
      }
    , resources = {=}
    , rollingParams = None RollingParams.Type
    , type = "Rolling"
    }
}
