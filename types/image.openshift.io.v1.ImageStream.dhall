{ Type =
{ apiVersion : Text
, kind : Text
, metadata : { name : Text }
, spec :
    { lookupPolicy : { local : Bool }
    , tags :
        List
          { from : { kind : Text, name : Text }
          , importPolicy : {}
          , name : Text
          , referencePolicy : { type : Text }
          }
    }
}
, default = {apiVersion =
                "image.openshift.io/v1"
            , kind = "ImageStream"}
}
