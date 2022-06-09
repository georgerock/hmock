module Lib
  ( handler
  ) where

import AWS.Lambda.Context (LambdaContext)
import AWS.Lambda.Events.SQS (SQSEvent)
import Model (Message)

handler :: LambdaContext -> SQSEvent -> IO (Either String Message)
handler = undefined
