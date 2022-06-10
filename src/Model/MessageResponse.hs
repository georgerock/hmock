module Model.MessageResponse where

import Control.Lens (makeLenses, makePrisms)
import Data.Aeson
import Data.Aeson.Casing (camelCase)
import Data.Aeson.Types
import Data.Text (Text)
import GHC.Generics (Generic)

data GenericResponse =
  GenericResponse
    { _grResponse :: Text
    , _grOtherField :: Integer
    , _grAnotherField :: Bool
    }
  deriving (Generic, Eq, Show)

$(makeLenses ''GenericResponse)

instance ToJSON GenericResponse where
  toJSON =
    genericToJSON $ defaultOptions {fieldLabelModifier = camelCase . drop 3}

instance FromJSON GenericResponse where
  parseJSON =
    genericParseJSON $ defaultOptions {fieldLabelModifier = camelCase . drop 3}

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

data MessageResponse
  = Gen GenericResponse
  | Err ErrorResponse
  deriving (Generic, Eq, Show)

$(makePrisms ''MessageResponse)

instance ToJSON MessageResponse where
  toJSON (Gen m) = toJSON m
  toJSON (Err e) = toJSON e

instance FromJSON MessageResponse where
  parseJSON o@(Object v) = do
    tag <- v .: "tag" :: Parser Text
    case tag of
      "GenericResponse" -> Gen <$> parseJSON o
      "ErrorResponse" -> Err <$> parseJSON o
      _ -> fail "No matching MessageResponse"
  parseJSON _ = fail "Invalid json datatype"
