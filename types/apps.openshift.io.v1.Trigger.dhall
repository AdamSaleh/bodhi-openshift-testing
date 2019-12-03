{ Type =
    { type : Text
    , imageChangeParams : Optional ./apps.openshift.v1.ImageChangeParams.dhall
    }
, default =
    { imageChangeParams = None ./apps.openshift.v1.ImageChangeParams.dhall }
}
