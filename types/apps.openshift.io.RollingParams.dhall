{ Type =
    { intervalSeconds : Natural
    , maxSurge : Text
    , maxUnavailable : Text
    , timeoutSeconds : Natural
    , updatePeriodSeconds : Natural
    }
, default =
      { intervalSeconds = 1
      , maxSurge = "25%"
      , maxUnavailable = "25%"
      , timeoutSeconds = 600
      , updatePeriodSeconds = 1
      }
}
