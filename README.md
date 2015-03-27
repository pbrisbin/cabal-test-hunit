# cabal-test-hunit

Interface for running HUnit tests via Cabal 1.16.

## Installation

~~~
git clone ... && cd ... && cabal install
~~~

## Usage

Add a suite to your cabal file:

~~~
Test-Suite test-your-thing
    type:          detailed-0.9
    test-module:   Test.YourTestModule
    build-depends: base
                 , Cabal
                 , HUnit
                 , cabal-test-hunit
~~~

Write some tests in `Test.YourTestModule`:

~~~ { .haskell }
import Test.HUnit

import qualified Distribution.TestSuite as C
import qualified Distribution.TestSuite.HUnit as H

tests :: IO [C.Test]
tests = return $ map (uncurry H.test) testCases

testCases :: [(String, Test)]
testCases = [("Truth tests", truthTest)]

truthTest :: Test
truthTest = TestCase $ assertEqual "True is true" True True
~~~

Run them:

~~~
cabal configure --enable-tests
cabal build
cabal test
~~~

## Prior work

An early version of this module, written by Thomas Tuegel in 2010, can 
be found in [this][cth] darcs repo.

[cth]: http://community.haskell.org/~ttuegel/cabal-test-hunit

This file shares no code with that one, as the changes in Cabal 1.16
required it be entirely rewritten. I've retained Thomas' LICENSE but
removed his copyright; I hope that's appropriate.
