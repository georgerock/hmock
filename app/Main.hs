module Main where

import AWS.Lambda.Runtime (ioRuntimeWithContext)
import Lib (handler)

main :: IO ()
main = ioRuntimeWithContext handler
