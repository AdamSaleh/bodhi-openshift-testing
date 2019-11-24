{ Volume =
    { secret = None ./types/apps.openshift.io.v1.Secret.dhall
    , configMap = None ./types/apps.openshift.v1.ConfigMap.dhall
    , emptyDir = None {}
    }
, Trigger =
    { imageChangeParams = None ./types/apps.openshift.v1.ImageChangeParams.dhall
    }
, VolumeMount = { readOnly = None Bool, subPath = None Text }
, Container =
    { resources = {=}
    , terminationMessagePath = "/dev/termination-log"
    , terminationMessagePolicy = "File"
    , volumeMounts =
        [] : List
               { mountPath : Text
               , name : Text
               , readOnly : Optional Bool
               , subPath : Optional Text
               }
    , env = [] : List {name : Text, value : Text}
    , command = [] : List Text
    , args = [] : List Text
    , ports = [] : List { containerPort : Natural, protocol : Text }
    , readinessProbe = None ./types/apps.openshift.io.v1.Probe.dhall
    , livenessProbe = None ./types/apps.openshift.io.v1.Probe.dhall
    }
, DeploymentStrategy =
    { activeDeadlineSeconds = 21600
    , recreateParams = { timeoutSeconds = 600 }
    , resources = {=}
    , rollingParams = None ./types/apps.openshift.io.RollingParams.dhall
    }
, RollingParams =
    { intervalSeconds = 1
    , maxSurge = "25%"
    , maxUnavailable = "25%"
    , timeoutSeconds = 600
    , updatePeriodSeconds = 1
    }
, RollingStrategy =
    { activeDeadlineSeconds = 21600
    , recreateParams = 
      { timeoutSeconds = 600 
      , post = None { execNewPod : { command : List Text }
          , containerName : Text
          , failurePolicy : Text
          }
      }
    , resources = {=}
    , rollingParams = Some
        { intervalSeconds = 1
        , maxSurge = "25%"
        , maxUnavailable = "25%"
        , timeoutSeconds = 600
        , updatePeriodSeconds = 1
        }
    , type = "Rolling"
    }
, Probe =
    { failureThreshold = 3
    , initialDelaySeconds = 30
    , periodSeconds = 10
    , successThreshold = 1
    , timeoutSeconds = 10
    , httpGet = None { path : Text, port : Natural, scheme : Text }
    , exec = None {command : List Text}
    }
, ProbeReady =
    { failureThreshold = 5
    , initialDelaySeconds = 10
    , periodSeconds = 10
    , successThreshold = 1
    , timeoutSeconds = 10
    , httpGet = None { path : Text, port : Natural, scheme : Text }
    , exec = None {command : List Text}
    }
, DeploymentTemplateSpec = {
    , dnsPolicy = "ClusterFirst"
    , restartPolicy = "Always"
    , schedulerName = "default-scheduler"
    , securityContext = {=}
    , terminationGracePeriodSeconds = 30
  }
}
