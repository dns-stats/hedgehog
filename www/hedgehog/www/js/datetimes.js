///
/// Copyright 2014 Internet Corporation for Assigned Names and Numbers.
///
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
///
/// http://www.apache.org/licenses/LICENSE-2.0
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
///
/// Developed by Sinodun IT (www.sinodun.com)
///

$(document).ready(function() {
    // This function is called when hedgehog.html has loaded.
    // Any other document.ready functions within included javascript
    // files will also be called non-deterministically.
    
    // register callback function for when the advanced time input selection link is clicked
    $("#tfadv").click(function() {
        $("#timeTabsBasic").addClass("hidden");
        $("#tfbasic").removeClass("strong");
        $("#timeTabsAdv").removeClass("hidden");
        $("#tfadv").addClass("strong");
    });
    
    // register callback function for when the basic time input selection link is clicked
    $("#tfbasic").click(function() {
        $("#timeTabsAdv").addClass("hidden");
        $("#tfadv").removeClass("strong");
        $("#timeTabsBasic").removeClass("hidden");
        $("#tfbasic").addClass("strong");
    });
    
    // this function is no longer used, since we removed the debug option from the production release
    $("#debug").click(function() {
        $("#debugadv").toggleClass("strong");
        $("#debug").toggleClass("strong");
    });
    
    // register a callback function for when the Today button is clicked
    $("#setToday").click(function set_today() {
        window.stop = new Date();
        window.stop.setUTCSeconds(0,0);
        set_start_to_stop_dt();
        set_start_to_stop_tm();
        window.start.setUTCMinutes(window.start.getUTCMinutes() + 1);
        getNewDateTime(window.start, -24);
        setAdvInputs();
        setUserDisplayMsg();
        $('#day').prop('checked', true);
    });
    
    // register a callback function for when the basic time control +< button is clicked
    $("#lextend").click(function() {
        extend_tframe("left");
    });
    
    // register a callback function for when the basic time control >+ button is clicked
    $("#rextend").click(function() {
        extend_tframe("right");
    });
    
    // register a callback function for when the basic time control < button is clicked
    $("#larrow").click(function() {
        shift_tframe("left");
    });
    
    // register a callback function for when the basic time control > button is clicked
    $("#rarrow").click(function() {
        shift_tframe("right");
    });
    
    // register a callback function for when any basic time control time frame buttons are clicked
    $("input:radio[name='tframe']").change(function() {
       set_tframe(parseInt($("input:radio[name='tframe']:checked").val()));
    });
    
    // register a callback function for when the advanced time control start input is changed
    $("#start").change(function() {
        new_start_str = $('#start').val() + ":00Z"
        if (window.start !== new_start_str) {
            window.start = new Date(new_start_str);
            setUserDisplayMsg();
        }            
    });
    
    // register a callback function for when the advanced time control stop input is changed
    $("#stop").change(function() {
        new_stop_str = $('#stop').val() + ":00Z"
        if (window.stop !== new_stop_str) {
            window.stop = new Date(new_stop_str);
            setUserDisplayMsg();
        }
    });
    
});


function setUserDisplayMsg() {
    // update timedisplay and userdisplay messages
    var tmsg = '<p class="remove-bottom"><span class="strong">From </span>' + window.start.toUTCString().replace('GMT','UTC') + '<br /><span class="strong">To </span>' + window.stop.toUTCString().replace('GMT','UTC') + '</p>';
    $('#timedisplay').html(tmsg);
    
    enableGenerate(true);
    
    var existing = $('#userdisplay').html();
    var invalidmsg = '<p class="error remove-bottom"><span class="strong">Error:</span> you have selected an End Date earlier than or equal to the Start date - please make a new selection</p>'; 
    
    if(window.stop <= window.start) {
        enableGenerate(false);
        if (existing.indexOf(invalidmsg) === -1) $('#userdisplay').html(existing + invalidmsg);
    } else {
        $('#userdisplay').html(existing.replace(invalidmsg, ""));
    }
    
    var existing = $('#userdisplay').html();
    var futuremsg = '<p class="warning remove-bottom"><span class="strong">Warning:</span> you have selected a future End Date - by default you will only see data up to the current moment</p>';
    
    if((window.stop > new Date()) || (window.start > new Date())){
        if (existing.indexOf(futuremsg) === -1) $('#userdisplay').html(existing + futuremsg);
    } else {
        $('#userdisplay').html(existing.replace(futuremsg, ""));
    }
}

function getNewDateTime(d, hours){
    // add / subtract the number of hours from datetime, d,
    // according to switch below and return new datetime
    // default will return the same date (no default case)
    switch(hours) {
        case -730:
            d.setMonth(d.getMonth() - 1); //d - 1 month
            break;
        case -168:
            d.setDate(d.getDate() - 7); //d - 1 week
            break;
        case -24:
            d.setDate(d.getDate() - 1); //d - 1 day
            break;
        case -12:
            d.setHours(d.getHours() - 12); //d - 12 hours
            break;
        case -4:
            d.setHours(d.getHours() - 4); //d - 4 hours
            break;
        case -1:
            d.setHours(d.getHours() - 1); //d - 1 hour
            break;
        case 1:
            d.setHours(d.getHours() + 1); //d + 1 hour
            break;
        case 4:
            d.setHours(d.getHours() + 4); //d + 4 hours
            break;
        case 12:
            d.setHours(d.getHours() + 12); //d + 12 hours
            break;
        case 24:
            d.setDate(d.getDate() + 1); //d + 1 day
            break;
        case 168:
            d.setDate(d.getDate() + 7); //d + 1 week
            break;
        case 730:
            d.setMonth(d.getMonth() + 1); //d + 1 month
            break;
    }
}

function reset_hours() {
    window.start.setUTCHours(0,0,0);
    window.stop.setUTCHours(23,59,0);
}

function set_start_to_stop_dt() {
    // sets start date equal to stop date
    window.start.setUTCFullYear(window.stop.getUTCFullYear(), window.stop.getUTCMonth(), window.stop.getUTCDate());
}

function set_start_to_stop_tm() {
    // sets start time equal to stop time
    window.start.setUTCHours(window.stop.getUTCHours(), window.stop.getUTCMinutes(), 0, 0);
}

function set_tframe(hours) {
    set_start_to_stop_dt();
    set_start_to_stop_tm();
    switch(hours) {
        case 1:
        case 4:
        case 12:
            window.start.setUTCHours(window.start.getUTCHours() - hours);
            break;
        case 24:
            window.start.setUTCDate(window.start.getUTCDate() - 1);          
            break;
        case 168:
            window.start.setUTCDate(window.start.getUTCDate() - 7);
            break;            
        case 730:
            window.start.setUTCMonth(window.start.getUTCMonth() - 1);
            break;
        default: // do a day
            window.start.setUTCDate(window.start.getUTCDate() + 1);          
            break;
    }
    window.start.setUTCMinutes(window.start.getUTCMinutes() + 1);
    setAdvInputs();
    setUserDisplayMsg();    
}

function shift_tframe(direction) {
    var hours = $("input[type='radio'][name='tframe']:checked").val() * 1; // current time frame increment selected
    if (direction === 'left') {
        hours = -hours;
    }
    getNewDateTime(window.start, hours);
    getNewDateTime(window.stop, hours);
    setAdvInputs();
    setUserDisplayMsg();
}

function extend_tframe(direction) {
    var hours = $("input[type='radio'][name='tframe']:checked").val() * 1; // current time frame increment selected
    if (direction === 'left') {
        getNewDateTime(window.start, -hours);
    }else if (direction === 'right') {
        getNewDateTime(window.stop, hours);
    }
    setAdvInputs();
    setUserDisplayMsg(); 
}

function setAdvInputs() {
    // sets the timeTabsAdv inputs
    // slice removes the final ":###Z" which is not accepted by datetime input
    $('#start').val(window.start.toISOString().slice(0,16));
    $('#stop').val(window.stop.toISOString().slice(0,16));
}