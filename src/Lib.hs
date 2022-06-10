module Lib
  ( handler
  ) where

import AWS.Lambda.Context (LambdaContext)
import Lib.Config
import Model.Message
import Model.MessageResponse

handler :: LambdaContext -> Message -> IO MessageResponse
handler _ (Message GenericMessage {..}) = do
  AppConfig {baseConfig = BaseConfig {appEnv}} <- loadConfig :: IO AppConfig
  return . Gen $ GenericResponse (_gmName <> " " <> appEnv) 42 _gmAnotherField
