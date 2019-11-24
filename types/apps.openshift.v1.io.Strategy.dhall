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
, rollingParams : Optional ./apps.openshift.io.RollingParams.dhall
, type : Text
}
