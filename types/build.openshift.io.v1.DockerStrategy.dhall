{ Type =
    { dockerStrategy : Optional { from : { kind : Text, name : Text } }
    , type : Text
    }
, defaults =
    { dockerStrategy = None { from : { kind : Text, name : Text } }
    , type = "Docker"
    }
}
