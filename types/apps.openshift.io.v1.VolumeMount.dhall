{ Type =
    { mountPath : Text
    , name : Text
    , readOnly : Optional Bool
    , subPath : Optional Text
    }
, default = { readOnly = None Bool, subPath = None Text }
}
