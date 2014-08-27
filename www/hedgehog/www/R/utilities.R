# 
# Copyright 2014 Internet Corporation for Assigned Names and Numbers.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# Developed by Sinodun IT (www.sinodun.com)
#

handleTimeframe <- function() {
	
	if (hh_debug) {
		system('logger -p user.notice In handleTimeFrame')
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
		system('logger -p user.notice In validateGetParams')
	}
	
	if (is.null(GET$type)) 
		return(FALSE)

    # Check that all calls to this function have the required parameters
	if (GET$type == "generatePlot" || GET$type == "generateYaml") {
		if (is.null(GET$start) || is.null(GET$stop)) {
			system('logger -p user.notice Invalid time')
			return(FALSE)
		}
		if (is.null(GET$pltid)) 	 {
			system('logger -p user.notice In Hedgehog:validateGetParams - invalid pltid')
			return(FALSE)
		}
		if (is.null(GET$svrid))		 {
			system('logger -p user.notice In Hedgehog:validateGetParams - invalid svrid')
			return(FALSE)
		}
		if (is.null(GET$gvis))			 {
			system('logger -p user.notice In Hedgehog:validateGetParams - invalid gvis')
			return(FALSE)
		}
		if (is.null(GET$svrnm)) 				 {
			system('logger -p user.notice In Hedgehog:validateGetParams - invalid svrnm')
			return(FALSE)
		}
		if (is.null(GET$ndarr))					 {
			system('logger -p user.notice In Hedgehog:validateGetParams - invalid ndarr')
			return(FALSE)
		}
		handleTimeframe()
	}   
	return(TRUE)
}