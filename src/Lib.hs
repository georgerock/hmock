module Lib
  ( handler
  ) where

import AWS.Lambda.Context (LambdaContext)
import AWS.Lambda.Events.SQS (SQSEvent)
import Model.MessageResponse (MessageResponse)

handler :: LambdaContext -> SQSEvent -> IO (Either String MessageResponse)
handler = undefined
