{ Type =
    { apiVersion : Text
    , kind : Text
    , metadata : { name : Text }
    , data : List { mapKey : Text, mapValue : Text }
    }
, default = { apiVersion = "v1", kind = "ConfigMap" }
}
