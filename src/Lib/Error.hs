module Lib.Error where

import Control.Exception
import Control.Monad.IO.Class (MonadIO(liftIO))
import Data.Aeson (ToJSON)
import Data.Text (Text)
import GHC.Generics (Generic)
import System.Log.FastLogger

class (MonadIO m) =>
      AppError m
  where
  withErrorHandling :: (Exception b) => IO a -> m (Either b a)

instance AppError IO where
  withErrorHandling action =
    liftIO $ do
      res <- try action
      case res of
        Right _ -> return res
        Left e ->
          withFastLogger (LogStdout defaultBufSize) $ \logFn -> do
            logFn $ toLogStr $ show e
            return $ Left e

data Error
  = DecodeError Text
  | AWSError Text
  | ConfigurationError Text
  | GenericError Text
  deriving (Generic, Eq, Show, Exception, ToJSON)
