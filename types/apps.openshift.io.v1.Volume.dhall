{ Type =
    { emptyDir : Optional {}
    , name : Text
    , secret : Optional ./apps.openshift.io.v1.Secret.dhall
    , configMap : Optional ./apps.openshift.v1.ConfigMap.dhall
    }
, default =
    { secret = None ./apps.openshift.io.v1.Secret.dhall
    , configMap = None ./apps.openshift.v1.ConfigMap.dhall
    , emptyDir = None {}
    }
}
