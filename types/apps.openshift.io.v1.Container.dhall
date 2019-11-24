let Probe = ./apps.openshift.io.v1.Probe.dhall

in  { image : Text
    , imagePullPolicy : Text
    , name : Text
    , resources : {}
    , env : List {name : Text, value : Text}
    , terminationMessagePath : Text
    , terminationMessagePolicy : Text
    , volumeMounts :
        List
          { mountPath : Text
          , name : Text
          , readOnly : Optional Bool
          , subPath : Optional Text
          }
    , command : List Text
    , args : List Text
    , ports : List { containerPort : Natural, protocol : Text }
    , readinessProbe : Optional Probe
    , livenessProbe : Optional Probe
    }
