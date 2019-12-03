let Trigger = ./apps.openshift.io.v1.Trigger.dhall
in
{ Type =
    { failedBuildsHistoryLimit : Natural
    , output : { to : { kind : Text, name : Text } }
    , postCommit : {}
    , resources : {}
    , runPolicy : Text
    , source : { dockerfile : Text, type : Text }
    , strategy : ((./build.openshift.io.v1.DockerStrategy.dhall).Type)
    , successfulBuildsHistoryLimit : Natural
    , triggers : List Trigger.Type
    }
, default =
    { failedBuildsHistoryLimit = 5
    , postCommit = {=}
    , resources = {=}
    , runPolicy = "Serial"
    , successfulBuildsHistoryLimit = 5
    , triggers = [] : List Trigger.Type
    }
}
