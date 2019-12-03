let Trigger = ./apps.openshift.io.v1.Trigger.dhall

let Strategy = ./apps.openshift.v1.io.Strategy.dhall

let TemplateSpec = ./apps.openshift.io.v1.DeploymentConfigTemplateSpec.dhall

in  { Type =
        { replicas : Natural
        , revisionHistoryLimit : Natural
        , selector : { deploymentconfig : Text }
        , strategy : Strategy.Type
        , template :
            { metadata : { labels : { app : Text, deploymentconfig : Text } }
            , spec : TemplateSpec.Type
            }
        , test : Bool
        , triggers : List Trigger.Type
        }
    , default = 
      { revisionHistoryLimit = 10
      , strategy = Strategy.default 
      , test = False
      , triggers = [] : List Trigger.Type}
    }
