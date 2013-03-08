-------------------------------------------------------------------------------
-- |
-- Module      :  Distribution.TestSuite.HUnit
-- Copyright   :  Patrick Brisbin 2013
--
-- Maintainer  :  pbrisbin@gmail.com
-- Portability :  portable
--
-- Test interface for running HUnit tests via cabal.
--
-- Usage:
--
-- > import Test.HUnit
-- >
-- > import qualified Distribution.TestSuite as C
-- > import qualified Distribution.TestSuite.HUnit as H
-- >
-- > tests :: IO [C.Test]
-- > tests = return $ map (uncurry H.test) testCases
-- >
-- > testCases :: [(String, Test)]
-- > testCases = [("Truth test", truthTest)]
-- >
-- > truthTest :: Test
-- > truthTest = assertEqual True True
--
-- An early version of this module, written by Thomas Tuegel
-- <ttuegel@gmail.com>, can be found at:
--
-- <http://community.haskell.org/~ttuegel/cabal-test-hunit>
--
-- This file shares no code with that one, as the changes in Cabal 1.16
-- required it be entirely rewritten. I've retained Thomas' LICENSE but
-- removed his copyright; I hope that's appropriate.
--
-------------------------------------------------------------------------------
module Distribution.TestSuite.HUnit (test) where

import Distribution.TestSuite
import qualified Test.HUnit as H

test :: String -> H.Test -> Test
test n = Test . testInstance n

testInstance :: String -> H.Test -> TestInstance
testInstance n t = TestInstance
    { run       = runTest t
    , name      = n
    , tags      = []
    , options   = []
    , setOption = \_ _ -> Right $ testInstance n t
    }

runTest :: H.Test -> IO Progress
runTest = fmap snd . H.performTest onStart onError onFailure (Finished Pass)

    where

        onStart :: H.State -> Progress -> IO Progress
        onStart _ = return

        onError :: String -> H.State -> Progress -> IO Progress
        onError msg _ _ = return $ Finished (Error msg)

        onFailure :: String -> H.State -> Progress -> IO Progress
        onFailure msg _ _ = return $ Finished (Fail msg)
