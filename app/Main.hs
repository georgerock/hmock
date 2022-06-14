module Main where

import AWS.Lambda.Runtime (mRuntimeWithContext)
import Lib (handler)

main :: IO ()
main = mRuntimeWithContext handler
