let Container = ./apps.openshift.io.v1.Container.dhall

let Volume = ./apps.openshift.io.v1.Volume.dhall

in  { Type =
        { containers : List Container.Type
        , dnsPolicy : Text
        , restartPolicy : Text
        , schedulerName : Text
        , securityContext : {}
        , terminationGracePeriodSeconds : Natural
        , volumes : List Volume.Type
        }
    , default =
        { dnsPolicy = "ClusterFirst"
        , restartPolicy = "Always"
        , schedulerName = "default-scheduler"
        , securityContext = {=}
        , terminationGracePeriodSeconds = 30
        }
    }
