module Lib.Config where

import Control.Exception (throw)
import Control.Monad (unless)
import Data.Text (Text)
import qualified Data.Text as T
import Dhall (FromDhall, Natural, auto, input)
import GHC.Generics (Generic)
import Lib.Error (Error(ConfigurationError))
import System.Environment (getEnv)

data Zone
  = Central Text
  | West Text
  deriving (Generic, Eq, Show, FromDhall)

data RegionConfig
  = Local
      { host :: Text
      , port :: Natural
      , zone :: Zone
      }
  | AWSZone Zone
  deriving (Generic, Eq, Show, FromDhall)

data S3Config
  = S3CfgLocal RegionConfig -- For localstack
  | S3CfgRepl RegionConfig -- For testing stuff with amazonka from the repl
  | S3CfgTest RegionConfig -- For tests, kinda irrelevant since it will be mocked
  | S3CfgDev RegionConfig -- For actual deploying to AWS, add more if you have more environments
  deriving (Generic, Eq, Show, FromDhall)

data BaseConfig =
  BaseConfig
    { appEnv :: Text
    , testApiUrl :: Text
    }
  deriving (Generic, Eq, Show, FromDhall)

data AppConfig =
  AppConfig
    { baseConfig :: BaseConfig
    , s3Config :: S3Config
    }
  deriving (Generic, Eq, Show, FromDhall)

loadConfig :: FromDhall a => IO a
loadConfig = do
  aEnv <- T.pack <$> getEnv "APP_ENV"
  let validEnv = aEnv `elem` (["local", "dev", "test"] :: [Text])
  unless validEnv $
    throw . ConfigurationError $ T.concat ["Invalid APP_ENV: ", aEnv]
  input auto $ T.concat ["./config/", aEnv, ".dhall"]
