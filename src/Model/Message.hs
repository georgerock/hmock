module Model.Message where

import Control.Lens (makeLenses)
import Data.Aeson
import Data.Aeson.Casing (camelCase)
import Data.Text (Text)
import GHC.Generics (Generic)

data GenericMessage =
  GenericMessage
    { _gmName :: Text
    , _gmOtherField :: Integer
    , _gmAnotherField :: Bool
    }
  deriving (Generic, Eq, Show)

$(makeLenses ''GenericMessage)

instance ToJSON GenericMessage where
  toJSON =
    genericToJSON $ defaultOptions {fieldLabelModifier = camelCase . drop 3}

instance FromJSON GenericMessage where
  parseJSON =
    genericParseJSON $ defaultOptions {fieldLabelModifier = camelCase . drop 3}

newtype Message =
  Message GenericMessage
  deriving (Generic, Eq, Show)

instance FromJSON Message where
  parseJSON o@(Object _) = Message <$> parseJSON o
  parseJSON _ = fail "Not an object"
