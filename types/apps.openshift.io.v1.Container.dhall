let Probe = ./apps.openshift.io.v1.Probe.dhall
let VolumeMount = ./apps.openshift.io.v1.VolumeMount.dhall
in { Type = { image : Text
    , imagePullPolicy : Text
    , name : Text
    , resources : {}
    , env : List {name : Text, value : Text}
    , terminationMessagePath : Text
    , terminationMessagePolicy : Text
    , volumeMounts :
        List VolumeMount.Type
          
    , command : List Text
    , args : List Text
    , ports : List { containerPort : Natural, protocol : Text }
    , readinessProbe : Optional Probe.Type
    , livenessProbe : Optional Probe.Type
    }
, default = {
resources = {=}
    , terminationMessagePath = "/dev/termination-log"
    , terminationMessagePolicy = "File"
    , volumeMounts =
        [] : List VolumeMount.Type
    , env = [] : List {name : Text, value : Text}
    , command = [] : List Text
    , args = [] : List Text
    , ports = [] : List { containerPort : Natural, protocol : Text }
    , readinessProbe = None Probe.Type
    , livenessProbe = None Probe.Type
    
}
}    
