///
/// Copyright 2014, 2015, 2016 Internet Corporation for Assigned Names and Numbers.
///
/// This Source Code Form is subject to the terms of the Mozilla Public
/// License, v. 2.0. If a copy of the MPL was not distributed with this
/// file, you can obtain one at https://mozilla.org/MPL/2.0/.
///
/// Developed by Sinodun IT (www.sinodun.com)
///

$(document).ready(function() {
    // This function is called when hedgehog.html has loaded.
    // Any other document.ready functions within included javascript
    // files will also be called non-deterministically.
    
    // hide advanced time controls
    $("#timeTabsAdv").addClass("hidden");

    // pre-select day from basic time handling
    $('#day').prop('checked', true);
    
    // initialise start and stop datetimes
    window.start = new Date();
    window.start.setUTCDate(window.start.getUTCDate() -1);
    window.stop = new Date(window.start);
    reset_hours();
    setAdvInputs();
    setUserDisplayMsg();
    
    // initialise customMsg
    window.customMsg = null;
    
    // initialise lastPlot and selectedOpt
    window.lastPlot = null;
    window.selectedOpt = null;

    // populate plot and server dropdowns and nodetabs then generate default plot    
    // , brew("initnodeslist"),
    $.when(brew("validateDBVersion"),brew("initPltType"), brew("initPlotDDHtml"), brew("initServerDDHtml"), 
           brew("getDefaultServer"), brew("initNodeData"), brew("getDefaultGrouping"), brew("getDefaultPlotId"), 
           brew("getSupportURL")).done(function(db,rp, pt, ss, ds, nd, dg, dp, su){

        if(db[0].indexOf("Error: Database version mismatch.") > -1) {
            setDbVersionlMsg(true);
            $("#outerplot").html('<div class="sixteen columns" id="plot"><hr /><img src="plots/no_connection.png" /><hr /></div>');
            return;
        }else if(db[0].indexOf("Error: Could not connect to the database") > -1) {
            setDbFailMsg(true);
            $("#outerplot").html('<div class="sixteen columns" id="plot"><hr /><img src="plots/no_connection.png" /><hr /></div>');
            return;
        }

        //initialise plot radio selection
        if (rp[0].indexOf('interactive') !== -1) {
            $('#googleviz').prop('checked', true);
        }

        // initialise plot drop down
        $("#plotType").html(pt[0]);
        $("#plotType").val(parseInt(dp[0]));

        // Initialise Server drop down item
        $("#servers").html(ss[0]);

        // check we have at least 1 server
        var servers_ok = server_list_has_content();
        if(!servers_ok) {
            alert("Error: No servers are configured in the database");
            $("#outerplot").html('<div class="sixteen columns" id="plot"><hr /><img src="plots/no_results.png" /><hr /></div>');
            setNoResultsMsg(true);
            return;
        }

        // checks user defined default for undefined, null and empty string
        if (!(!ds[0] || ds[0].length === 0 || !ds[0].trim())) {
            var options= document.getElementById('servers').options;
            for (var i = 0; i < options.length; i++) {
                if (options[i].text === ds[0].trim()) {
                    options[i].selected = true;
                    break;
                }
            }
        }

        // initialise node tabs and grouping
        initNodeHtml(nd[0]);
        $('#ng_' + dg[0]).prop('checked', true);

        setServersGroups();
        initnodetabs();
        serverTab();
        
        // checks for undefined, null and empty string
        if (!(!su[0] || su[0].length === 0 || !su[0].trim())) {
            $("#support_link").attr('href', su[0]);
        }

        // generate default plot
        genDSCGraph();
        setInitHelpMsg(true);

    });
    
    // register callback function for when the static / interactive radio buttons are clicked
    $("input[type='radio'][name='rbplot']").click(function() {
        enableGenerate(true);
    });
    
    // register callback function for when the plot drop down selection is changed
    $("#plotType").change(function() {
       enableGenerate(true);
    });

    // register callback function for when the generate plot button is clicked
    $("#generate").click(function() {
        genDSCGraph();
    });

});

function enableGenerate(ind) {
    // enable or disable the generate plot button
    if(ind){
        $('#generate').prop("disabled", false);
        $('#generate').attr("title", "Select all the criteria for your plot, then click 'Generate Plot'");
        setNoResultsMsg(false);
        setInitHelpMsg(false);
    }else{
        $('#generate').prop("disabled", true);
        $('#generate').attr("title", "Select new plot criteria to activate this button.");
    }
}

function brew(divId) {
    // call hedgehog.brew with type parameter set to the calling divId
    return $.ajax({
        url: "brew/hedgehog.brew",
        data: { 'type': divId}
    });
}

function genDSCGraph() {
    // call hedgehog.brew to generate a plot
    var gvis = 0;
    if ($('#googleviz').prop('checked') === true) gvis = 1;

    var pltid = $("#plotType option:selected").val();
    var svrnm_tmp = $("#servers option:selected").text();
    var svrnm = parse_name(svrnm_tmp);
    var svrid = $("#servers option:selected").val();
        
    var ndset = {};
    var allselected = true;
    $("input[type='checkbox'].nodeselection").each(function(){
        if( $(this).attr('id').split('_')[2] === svrnm) {
            if( $(this).is(':checked') ) {
                var node_id = $(this).attr('id').split("_")[0];
                ndset[node_id] = true;
            }else{
                allselected = false;
            }
        }
    });
    var ndarr = "";
    if (allselected){
        ndarr = -1;
    }else{
        for(var node in ndset){
            ndarr = ndarr + node + ",";
        }
        ndarr = ndarr.substring(0, ndarr.length - 1);
        if(ndarr === '') {
            window.alert("You must select at least one node")
            return
        }
    }
    
    var request = $.ajax({
        url: "brew/hedgehog.brew",
        data: { 'type': "generatePlot",
                'start': window.start.toISOString().slice(0,16),
                'stop': window.stop.toISOString().slice(0,16),
                'gvis': gvis,
                'pltid': pltid,
                'svrnm' : svrnm,
                'svrid': svrid,
                'ndarr': ndarr},
        beforeSend: function() {
                enableGenerate(false);
                $('body').css('cursor', 'wait');
                $("#outerplot").html('<hr /><img src="images/ajax-loader.gif" alt="loading..." /><hr />');
        }
    });
            
    request.done(function(data) {
        $("#outerplot").html(data);
        $('body').css('cursor', 'auto');
        setUserMsg(null);
        if (window.lastPlot === pltid){
            if(window.selectedOpt !== null) {
                if ( $(window.selectedOpt).prop('checked') === false ){
                    $(window.selectedOpt).prop('checked', true);
                    toggle_plot();
                }
                
            }
        }
        window.lastPlot = pltid;
    });
    
    request.fail(function(jqXHR, textStatus) {
        $("#outerplot").html('<div class="sixteen columns" id="plot"><hr /><img src="plots/no_results.png" /><hr /></div>');
        $('body').css('cursor', 'auto');
        enableGenerate(true);
        setUserMsg("Request failed with status '" + textStatus + "'");
        window.lastPlot = null;
    });
}


function toggle_plot() {  
    // hide and display linear, stacked or log plots based on user selection
    if ($("#rbliny").prop('checked')) {
        window.selectedOpt = "#rbliny";
        $('#liny').removeClass('hidden');
        $('#logy').addClass('hidden');
        $('#stack').addClass('hidden');
        $("#ploturi").val($("#liny").prop("name"));
    } else if ($("#rblogy").prop('checked')) {
        window.selectedOpt = "#rblogy";
        $('#liny').addClass('hidden');
        $('#logy').removeClass('hidden');
        $('#stack').addClass('hidden');
        $("#ploturi").val($("#logy").prop("name"));
    } else if ($("#rbstack").prop('checked')) {
        window.selectedOpt = "#rbstack";
        $('#liny').addClass('hidden');
        $('#logy').addClass('hidden');
        $('#stack').removeClass('hidden');
        $("#ploturi").val($("#stack").prop("name"));
    }
}

function setCustomMsg(msg) {
    var existing = $('#userdisplay').html();
    if (window.customMsg !== null) {
        if (existing.indexOf(window.customMsg) !== -1) $('#userdisplay').html(existing.replace(window.customMsg, ""));
        window.customMsg = null;
    }
    if (msg !== null) {
        window.customMsg = '<p class="error remove-bottom"><span class="strong">Error:</span> ' + msg + '</p>';
        if (existing.indexOf(window.customMsg) === -1) $('#userdisplay').html(existing + window.customMsg);
    }
}

function setInitHelpMsg(ind) {
    var existing = $('#userdisplay').html();
    var msg = '<p class="info remove-bottom"><span class="strong">Info:</span> To generate a new plot, change the time, node or plot type and click \'Generate Plot.\'</p>';
    if (ind) {
        if (existing.indexOf(msg) === -1) $('#userdisplay').html(existing + msg);
    } else {
        $('#userdisplay').html(existing.replace(msg, ""));
    }
}

function setDbFailMsg(ind) {
    var existing = $('#userdisplay').html();
    var msg = '<p class="error remove-bottom"><span class="strong">Error:</span> How embarrassing! We have been unable to connect to the database. Please contact an administrator.</p>';
    if (ind) {
        if (existing.indexOf(msg) === -1) $('#userdisplay').html(existing + msg);
    } else {
        $('#userdisplay').html(existing.replace(msg, ""));
    }
}

function setDbVersionlMsg(ind) {
    var existing = $('#userdisplay').html();
    var msg = '<p class="error remove-bottom"><span class="strong">Error:</span> There is a database version mismatch between the GUI and the database. Please contact an administrator.</p>';
    if (ind) {
        if (existing.indexOf(msg) === -1) $('#userdisplay').html(existing + msg);
    } else {
        $('#userdisplay').html(existing.replace(msg, ""));
    }
}

function setNoResultsMsg(ind) {
    var existing = $('#userdisplay').html();
    var msg = '<p class="info remove-bottom"><span class="strong">Info:</span> Sorry, your query didn\'t return any results. Please try again with new selection criteria.</p>';
    if (ind) {
        if (existing.indexOf(msg) === -1) $('#userdisplay').html(existing + msg);
    } else {
        $('#userdisplay').html(existing.replace(msg, ""));
    }
}

function setPlotNotSupportedMsg(ind) {
    var existing = $('#userdisplay').html();
    var msg = '<p class="info remove-bottom"><span class="strong">Info:</span> Sorry, this plot is not yet supported. Please try again with a different plot.</p>';
    if (ind) {
        if (existing.indexOf(msg) === -1) $('#userdisplay').html(existing + msg);
    } else {
        $('#userdisplay').html(existing.replace(msg, ""));
    }
}

function setUserMsg(msg) {
    setCustomMsg(msg);
    if ($('#outerplot').html().indexOf("plots/no_graph.png") !== -1) {
        setPlotNotSupportedMsg(true);
    } else {
        setPlotNotSupportedMsg(false);
    }
    if ($('#outerplot').html().indexOf("plots/no_results.png") !== -1) {
        setNoResultsMsg(true);
    } else {
        setNoResultsMsg(false);
    }
    if ($('#outerplot').html().indexOf("plots/no_connection.png") !== -1) {
        setDbFailMsg(true);
    } else {
        setDbFailMsg(false);
    }
}

function server_list_has_content() {
    if ($("#servers option:selected").text() == '') {
        return false;
    } else {
        return true;
    }
}
