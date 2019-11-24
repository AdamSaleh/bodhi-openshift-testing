{ apiVersion : Text
          , kind : Text
          , metadata : { labels : { build : Text }, name : Text }
          , spec :
              { failedBuildsHistoryLimit : Natural
              , output : { to : { kind : Text, name : Text } }
              , postCommit : {}
              , resources : {}
              , runPolicy : Text
              , source : { dockerfile : Text, type : Text }
              , strategy : { dockerStrategy : Optional ./build.openshift.io.v1.DockerStrategy.dhall, type : Text }
              , successfulBuildsHistoryLimit : Natural
              , triggers : List ./apps.openshift.io.v1.Trigger.dhall
              }
          }