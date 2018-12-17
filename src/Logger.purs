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

module Engineering.Services.Logger where


import Data.Function.Uncurried (Fn2, runFn2)
import Data.Generic.Rep as G
import Data.Generic.Rep.Show as GShow
import Data.String (toLower)
import Effect (Effect)
import Prelude (class Show, Unit, map, show)

-- | Types and Effect for Winston Logger

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
           | Scheduler
           | SequelizeL

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

schedulerLevel :: LogLevel
schedulerLevel = LogLevel Scheduler

sequelizeLevel :: LogLevel
sequelizeLevel = LogLevel SequelizeL

foreign import _log :: forall a. Fn2 String a (Effect Unit)

-- | Takes a string and logs using winston
log' :: forall m. LogLevel -> m -> Effect Unit
log' level msg = runFn2 _log (map toLower show level) (msg)

-- | Defining each log method, each takes a message and a LogLevel
trace :: forall m. m ->  Effect Unit
trace m = do
  log' traceLevel m

input :: forall m. m ->  Effect Unit
input m = do
  log' inputLevel m

verbose' :: forall m. m ->  Effect Unit
verbose' m = do
  log' verboseLevel m

prompt :: forall m. m ->  Effect Unit
prompt m = do
  log' promptLevel m

debug' :: forall m. m ->  Effect Unit
debug' m = do
  log' debugLevel m

info :: forall m. m ->  Effect Unit
info m = do
  log' infoLevel m

data' :: forall m. m ->  Effect Unit
data' m = do
  log' dataLevel m

help' :: forall m. m ->  Effect Unit
help' m = do
  log' helpLevel m

warn :: forall m. m ->  Effect Unit
warn m = do
  log' warnLevel m

error :: forall m. m ->  Effect Unit
error m = do
  log' errorLevel m

scheduler :: forall m. m ->  Effect Unit
scheduler m = do
  log' schedulerLevel m

sequelize :: String -> Effect Unit
sequelize m = do
  log' sequelizeLevel m
