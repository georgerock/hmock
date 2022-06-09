module Model where

import Control.Lens (makeLenses, makePrisms)
import Data.Aeson
import Data.Aeson.Types
import Data.Text (Text)
import GHC.Generics (Generic)

data GenericResponse =
  GenericResponse
    { _field :: String
    , _otherField :: Integer
    , _anotherField :: Bool
    }
  deriving (Generic, Eq, Show)

$(makeLenses ''GenericResponse)

instance ToJSON GenericResponse where
  toJSON = genericToJSON $ defaultOptions {fieldLabelModifier = drop 1}

instance FromJSON GenericResponse where
  parseJSON = genericParseJSON $ defaultOptions {fieldLabelModifier = drop 1}

data ErrorResponse =
  ErrorResponse
    { _err :: String
    , _isCritical :: Bool
    }
  deriving (Generic, Eq, Show)

instance ToJSON ErrorResponse where
  toJSON = genericToJSON $ defaultOptions {fieldLabelModifier = drop 1}

instance FromJSON ErrorResponse where
  parseJSON = genericParseJSON $ defaultOptions {fieldLabelModifier = drop 1}

$(makeLenses ''ErrorResponse)

data Message
  = Gen GenericResponse
  | Err ErrorResponse
  deriving (Generic, Eq, Show)

$(makePrisms ''Message)

instance ToJSON Message where
  toJSON (Gen m) = toJSON m
  toJSON (Err e) = toJSON e

instance FromJSON Message where
  parseJSON o@(Object v) = do
    tag <- v .: "tag" :: Parser Text
    case tag of
      "GenericResponse" -> Gen <$> parseJSON o
      "ErrorResponse" -> Err <$> parseJSON o
      _ -> fail "No matching message"
  parseJSON _ = fail "Invalid json datatype"
