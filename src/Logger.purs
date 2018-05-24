{-
 Copyright (c) 2012-2017 "JUSPAY Technologies"
 JUSPAY Technologies Pvt. Ltd. [https://www.juspay.in]
 This file is part of JUSPAY Platform.
 JUSPAY Platform is free software: you can redistribute it and/or modify
 it for only educational purposes under the terms of the GNU Affero General
 Public License (GNU AGPL) as published by the Free Software Foundation,
 either version 3 of the License, or (at your option) any later version.
 For Enterprise/Commerical licenses, contact <info@juspay.in>.
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  The end user will
 be liable for all damages without limitation, which is caused by the
 ABUSE of the LICENSED SOFTWARE and shall INDEMNIFY JUSPAY for such
 damages, claims, cost, including reasonable attorney fee claimed on Juspay.
 The end user has NO right to claim any indemnification based on its use
 of Licensed Software. See the GNU Affero General Public License for more details.
 You should have received a copy of the GNU Affero General Public License
 along with this program. If not, see <https://www.gnu.org/licenses/agpl.html>.
-}

module Logger where


import Control.Monad.Eff (Eff, kind Effect)
import Data.Function.Uncurried (Fn2, runFn2)
import Data.Generic.Rep as G
import Data.Generic.Rep.Show as GShow
import Data.String (toLower)
import Prelude (class Show, Unit, map, show)

-- | Types and Effect for Winston Logger
foreign import data WINSTON :: Effect

foreign import data Winston :: Type

-- | Creating log levels
data Level = Trace
           | Input
           | Verbose
           | Prompt
           | Debug
           | Info
           | Data
           | Help
           | Warn
           | Error
           | Sapir
           | Fapir

derive instance genericLevel :: G.Generic Level _

instance showLevel :: Show Level where
  show a = GShow.genericShow a

-- | LogLevel TODO: Move priority, color and level configs here from JS
-- | data LogLevel = LogLevel Level Priority Color
data LogLevel = LogLevel Level

instance showLogLevel :: Show LogLevel where
  show (LogLevel level) = show level

-- | Creating Levels
traceLevel :: LogLevel
traceLevel = LogLevel Trace

inputLevel :: LogLevel
inputLevel = LogLevel Input

verboseLevel :: LogLevel
verboseLevel = LogLevel Verbose

promptLevel :: LogLevel
promptLevel = LogLevel Prompt

debugLevel :: LogLevel
debugLevel = LogLevel Debug

infoLevel :: LogLevel
infoLevel = LogLevel Info

dataLevel :: LogLevel
dataLevel = LogLevel Data

helpLevel :: LogLevel
helpLevel = LogLevel Help

warnLevel :: LogLevel
warnLevel = LogLevel Warn

errorLevel :: LogLevel
errorLevel = LogLevel Error

sapirLevel :: LogLevel
sapirLevel = LogLevel Sapir

fapirLevel :: LogLevel
fapirLevel = LogLevel Fapir

foreign import _log :: forall eff. Fn2 String String (Eff (wn :: WINSTON | eff) Unit)

-- | Takes a string and logs using winston
log' :: forall eff m. Show m => LogLevel -> m -> Eff (wn :: WINSTON |  eff) Unit
log' level msg = runFn2 _log (map toLower show level) (show msg)

-- | Defining each log method, each takes a message and a LogLevel
trace :: forall eff m. Show m => m ->  Eff (wn :: WINSTON | eff) Unit
trace m = do
  log' traceLevel m

input :: forall eff m. Show m => m ->  Eff (wn :: WINSTON | eff) Unit
input m = do
  log' inputLevel m

verbose' :: forall eff m. Show m => m ->  Eff (wn :: WINSTON | eff) Unit
verbose' m = do
  log' verboseLevel m

prompt :: forall eff m. Show m => m ->  Eff (wn :: WINSTON | eff) Unit
prompt m = do
  log' promptLevel m

debug' :: forall eff m. Show m => m ->  Eff (wn :: WINSTON | eff) Unit
debug' m = do
  log' debugLevel m

info :: forall eff m. Show m => m ->  Eff (wn :: WINSTON | eff) Unit
info m = do
  log' infoLevel m

data' :: forall eff m. Show m => m ->  Eff (wn :: WINSTON | eff) Unit
data' m = do
  log' dataLevel m

help' :: forall eff m. Show m => m ->  Eff (wn :: WINSTON | eff) Unit
help' m = do
  log' helpLevel m

warn :: forall eff m. Show m => m ->  Eff (wn :: WINSTON | eff) Unit
warn m = do
  log' warnLevel m

error :: forall eff m. Show m => m ->  Eff (wn :: WINSTON | eff) Unit
error m = do
  log' errorLevel m

sapir :: forall eff m. Show m => m ->  Eff (wn :: WINSTON | eff) Unit
sapir m = do
  log' sapirLevel m

fapir :: forall eff m. Show m => m ->  Eff (wn :: WINSTON | eff) Unit
fapir m = do
  log' fapirLevel m
