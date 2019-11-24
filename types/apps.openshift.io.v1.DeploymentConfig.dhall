let Volume = ./apps.openshift.io.v1.Volume.dhall
let Container = ./apps.openshift.io.v1.Container.dhall
let Trigger = ./apps.openshift.io.v1.Trigger.dhall
let Strategy = ./apps.openshift.v1.io.Strategy.dhall
in
{ apiVersion : Text
          , kind : Text
          , metadata : { labels : { app : Text, service : Text }, name : Text }
          , spec :
              { replicas : Natural
              , revisionHistoryLimit : Natural
              , selector : { deploymentconfig : Text }
              , strategy : Strategy
              , template :
                  { metadata :
                      { labels : { app : Text, deploymentconfig : Text } }
                  , spec :
                      { containers : List Container
                      , dnsPolicy : Text
                      , restartPolicy : Text
                      , schedulerName : Text
                      , securityContext : {}
                      , terminationGracePeriodSeconds : Natural
                      , volumes : List Volume
                      }
                  }
              , test : Bool
              , triggers : List Trigger
              }
          }