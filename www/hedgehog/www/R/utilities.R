# 
# Copyright 2014, 2015, 2016 Internet Corporation for Assigned Names and Numbers.
# 
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at https://mozilla.org/MPL/2.0/.

#
# Developed by Sinodun IT (www.sinodun.com)
#

handleTimeframe <- function() {
	
	if (hh_debug) {
		system('logger -p user.notice Hedgehog: In handleTimeFrame')
	}
    
	# Ensure data being pulled back is no more recent than presentation_delay_in_hours ago
	lag_end <- format(Sys.time() - (gui_config$www$presentation_delay_in_hours*60*60), '%Y-%m-%dT%H:%M')
	
	if (GET$stop > lag_end) {
		start_shift <- as.numeric(difftime(as.POSIXct(sub("T", " ", GET$stop)),as.POSIXct(sub("T", " ", GET$start)),units="hours"))
		GET$stop    <<- lag_end
		GET$start   <<- format(as.POSIXct(sub("T", " ", GET$stop)) - (start_shift*60*60), '%Y-%m-%dT%H:%M')
	}
}

# Check that all calls to this function have the required parameters
validateGetParams <- function() {
	
	if (hh_debug) {
		system('logger -p user.notice Hedgehog: In validateGetParams')
	}
	
	if (is.null(GET$type)) 
		return(FALSE)

    # Check that all calls to this function have the required parameters
	if (GET$type == "generatePlot" || GET$type == "generateYaml") {
		if (is.null(GET$start) || is.null(GET$stop)) {
			system('logger -p user.notice Hedgehog: Invalid time')
			return(FALSE)
		}
		if (is.null(GET$pltid)) 	 {
			system('logger -p user.notice Hedgehog: In Hedgehog:validateGetParams - invalid pltid')
			return(FALSE)
		}
		if (is.null(GET$svrid))		 {
			system('logger -p user.notice Hedgehog: In Hedgehog:validateGetParams - invalid svrid')
			return(FALSE)
		}
		if (is.null(GET$gvis))			 {
			system('logger -p user.notice Hedgehog: In Hedgehog:validateGetParams - invalid gvis')
			return(FALSE)
		}
		if (is.null(GET$svrnm)) 				 {
			system('logger -p user.notice Hedgehog: In Hedgehog:validateGetParams - invalid svrnm')
			return(FALSE)
		}
		if (is.null(GET$ndarr))					 {
			system('logger -p user.notice Hedgehog: In Hedgehog:validateGetParams - invalid ndarr')
			return(FALSE)
		}
		handleTimeframe()
	}   
	return(TRUE)
}