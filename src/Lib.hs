module Lib
  ( handler
  ) where

import AWS.Lambda.Context (LambdaContext)
import AWS.Lambda.Events.SQS (SQSEvent)
import Model.Message
import Model.MessageResponse

handler :: LambdaContext -> Message -> IO MessageResponse
handler _ (Message GenericMessage {..}) =
  return . Gen $
  GenericResponse ("Hello " <> _gmName <> "!") _gmOtherField _gmAnotherField
