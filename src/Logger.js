/*
* Copyright (c) 2012-2017 "JUSPAY Technologies"
* JUSPAY Technologies Pvt. Ltd. [https://www.juspay.in]
*
* This file is part of JUSPAY Platform.
*
* JUSPAY Platform is free software: you can redistribute it and/or modify
* it for only educational purposes under the terms of the GNU Affero General
* Public License (GNU AGPL) as published by the Free Software Foundation,
* either version 3 of the License, or (at your option) any later version.
* For Enterprise/Commerical licenses, contact <info@juspay.in>.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  The end user will
* be liable for all damages without limitation, which is caused by the
* ABUSE of the LICENSED SOFTWARE and shall INDEMNIFY JUSPAY for such
* damages, claims, cost, including reasonable attorney fee claimed on Juspay.
* The end user has NO right to claim any indemnification based on its use
* of Licensed Software. See the GNU Affero General Public License for more details.
*
* You should have received a copy of the GNU Affero General Public License
* along with this program. If not, see <https://www.gnu.org/licenses/agpl.html>.
*/

"use strict";

var winston = require("winston");

var env = process.env.NODE_ENV || "development";
// var config = require('../config/config.js')[env];
var application = process.env.NODE_APP || "app";
var APP_LOG = process.env.LOG_FILE;
var moment = require("moment-timezone");
var os = require("os");
var winstonConfig = require("../../node_modules/winston/lib/winston/config");

var customLevels = {
    levels: {
        trace: 0,
        input: 1,
        verbose: 2,
        prompt: 3,
        debug: 4,
        info: 5,
        data: 6,
        help: 7,
        warn: 8,
        error: 9,
        sapir: 5,
        fapir: 5
    },
    colors: {
        trace: 'magenta',
        input: 'grey',
        verbose: 'cyan',
        prompt: 'grey',
        debug: 'blue',
        info: 'green',
        data: 'grey',
        help: 'cyan',
        warn: 'yellow',
        error: 'red',
        sapir: 'green',
        fapir: 'red'
    }
};

// Create a new global logger
var logger = new(winston.Logger)({
    levels: customLevels.levels,
    transports: [
        new(winston.transports.Console)({
            timestamp: function() {
                return moment().utcOffset("+05:30").format("DD-MM-YYYY HH:mm:SS");
            },
            formatter: function(options) {
                return options.timestamp() + " " + os.hostname() + " " + env + " " + winstonConfig.colorize(options.level) + " " +
                    (undefined !== options.message ? options.message : "") +
                    (options.meta && Object.keys(options.meta).length ? "\n\t" + JSON.stringify(options.meta) : '');
            },
            colorize: true
        }),
        new(winston.transports.File)({
            filename: APP_LOG || "./" + application + ".data.log",
            json: true,
            colorize: false
        })
    ]
});

// Add colors if development, can be later moved to config
if (env === 'development') {
    winston.addColors(customLevels.colors);
};

// Logging helper
var _log = function(level, message) {
    return function() {
        logger.log(level, message);
        return {};
    };
};

exports._log = _log;
