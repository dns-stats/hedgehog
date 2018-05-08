///
/// Copyright 2014, 2015, 2016 Internet Corporation for Assigned Names and Numbers.
///
/// This Source Code Form is subject to the terms of the Mozilla Public
/// License, v. 2.0. If a copy of the MPL was not distributed with this
/// file, you can obtain one at https://mozilla.org/MPL/2.0/.
///
/// Developed by Sinodun IT (www.sinodun.com)
///

var sortByText = function (a, b) {
     return $.trim($(a).text()).localeCompare($.trim($(b).text()));
}

function parse_name( myid ) {
    // Need to process the server name as it could contain full stops.
    // Whilst these are allowed in identifiers if escaped their use complicates the code
    // So instead replace the full stop with a different character.
    // In CSS identifiers can contain only the characters [a-zA-Z0-9] and ISO 10646
    // characters U+00A0 and higher, plus the hyphen (-) and the underscore (_). 
    // We can't use with hyphen or underscore here, so use the Pound sign (U+00A3) which is valid.

    return myid.replace( /\./g, "£" );
}

function initNodeHtml(nodes_raw, enable_node_selection) {

    // Example data format
    // var nodes = [
    //   { server:     "Server-A",
    //     groups:     [{group_name: "Region-1", node_list: [{node_name: "Node-1", node_id: "1"}, {node_name: "Node-2", node_id: "2", node_country: "US", node_city: "City-1", node_sg: "Subgroup-1"}]},
    //                  {group_name: "Region-2", node_list: [{node_name: "Node-3", node_id: "3"}, {node_name: "Node-4", node_id: "4", node_country: "US", node_city: "City-1", node_sg: "Subgroup-2"}]}]},
    //   { server:     "L-root",
    //     groups:     [{group_name: "Europe",  node_list: [{node_name: "Node-5", node_id: "5"}, {node_name: "Node-6", node_id: "6", node_country: "US", node_city: "City-1", node_sg: "Subgroup-3"}}]},
    //                  {group_name: "America", node_list: [{node_name: "Node-7", node_id: "7"}, {node_name: "Node-8", node_id: "8", node_country: "US", node_city: "City-1", node_sg: "Subgroup-3"}}]}]}];

    nodes= jQuery.parseJSON(nodes_raw);

    // Append requires a full element and will close any open elements so need care when using it.
    $('#nodetabs').append("<div class='sixteen columns' id='groupcontent'></div>");
    $('#nodetabs').append("<br class='clear'>");
    $('#nodetabs').append("<div class='sixteen columns' id='nodecontent'>");
    $('#srvr_select').append("<a style='font-weight:bold; font-size:80%; text-decoration: none; padding-left: 20px; padding-right: 5px;'>Group by:</a>");
    $('#srvr_select').append("<input type='radio'          id='ng_country'  name='node_grouping' onclick='ngChanged()' ><label style='font-weight:bold;' for='ng_country'  >Country </label>");
    $('#srvr_select').append("<input type='radio'          id='ng_city'     name='node_grouping' onclick='ngChanged()' ><label style='font-weight:bold;' for='ng_city'     >City </label>");
    $('#srvr_select').append("<input type='radio'          id='ng_instance' name='node_grouping' onclick='ngChanged()' ><label style='font-weight:bold;' for='ng_instance' >Instance </label>");
    if (enable_node_selection == 1) {$('#srvr_select').append("<input type='radio'          id='ng_none'     name='node_grouping' onclick='ngChanged()' ><label style='font-weight:bold;' for='ng_none'     >Node </label>");}

    // Check for no servers is made earlier, so just check for nodes here
    // if (nodes_raw = "[]") {
    //     alert("No nodes found in the database");
    // }

    //*** SERVERS ***//
    // For each server, construct the groups.
    for (var i = 0; i < nodes.length; i++) {
        var server_tmp = nodes[i].server;
        var server     = parse_name(server_tmp);
        $('#groupcontent'       ).append(  "<div class='hidden' id='" + server + "'>");
        $('#' + server          ).append(  "<div class='Tabs'   id='" + server + "_tabs'>");
        $('#' + server + '_tabs').append(  "<ul                 id='" + server +"_tabs_ul'>");
        //***  GROUPS (REGIONS) ***//
        // For each group, add a tab and fill in the nodes
        for (var j = 0; j < nodes[i].groups.length; j++) {
            var group_tmp = nodes[i].groups[j].group_name;
            var group     = parse_name(group_tmp);
            var group_server       = group + "_" + server;
            var group_server_basic = group_server;
            // Create the top tab with a list entry
            $('#' + server + '_tabs_ul').append("<li id='li_" + group_server + "' onclick='gpTab(\"" + group_server + "\")'>  <a>" + group_tmp + "<img id='cb_" + group_server +"_img' src='images/all.png' alt='all selected' height='10' width='10'></a></li>");
            //Now the node content divs
            for (var node_grouping_options = 0; node_grouping_options <=3; node_grouping_options++) {
                if (node_grouping_options == 1)      {group_server = group + "_" + server + "_subgroup";}
                else if (node_grouping_options == 2) {group_server = group + "_" + server + "_city";}
                else if (node_grouping_options == 3) {group_server = group + "_" + server + "_country";}
                $('#nodecontent'                 ).append("<div class='group_showing'   id='" + group_server + "'>");
                $('#' + group_server             ).append("<div class='allnone'         id='" + group_server + "_allnone'>");
                $('#' + group_server             ).append("<div class='node_cbs'        id='" + group_server + "_node_cbs_id'>");
                // Selection buttons
                $('#' + group_server + '_allnone').append("<a style='font-weight:bold;'>Actions:</a>");
                if (j == -1) {
                    $('#' + group_server + '_allnone').append("<input type='button' id='selectAllBtn2'  value='Select all nodes'    title='Select all available nodes for plotting' onclick='selectAll(\"cb_" + group_server_basic + "\")'>"); 
                    $('#' + group_server + '_allnone').append("<input type='button' id='selectNoneBtn2' value='De-select all nodes' title='De-select all available nodes'           onclick='selectNone(\"cb_" + group_server_basic + "\")'><hr>");
                } else {
                    $('#' + group_server + '_allnone').append("<input type='button' id='selectOnlyRegionBtn' value='Select only " + group + "' title='Select only the nodes in this region for plotting'   onclick='selectOnly(\"cb_" + group_server_basic + "\")'> ");
                    $('#' + group_server + '_allnone').append("<input type='button' id='selectAllRegionBtn'  value='Include all " + group + "' title='Include all the nodes in this region for plotting'   onclick='selectAll(\"cb_"  + group_server_basic + "\")'> ");
                    $('#' + group_server + '_allnone').append("<input type='button' id='selectNoneRegionBtn' value='Exclude all " + group + "' title='De-select all the nodes in this region for plotting' onclick='selectNone(\"cb_" + group_server_basic + "\")'><hr> ");
                }
                //*** NODES AND GROUPING OPTIONS***//
                for (var k = 0; k < nodes[i].groups[j].node_list.length; k++) {
                    var node                 = nodes[i].groups[j].node_list[k]
                    var node_id_group_server = node.node_id + "_" + group_server_basic;
                    if (node_grouping_options == 0) {
                        $('#' + group_server + '_node_cbs_id').append("<input type='checkbox' class='nodeselection' id='" + node_id_group_server + "' name='cb_" + group_server + "' onclick='selectNode(\"" + node_id_group_server + "\")'>");
                        $('#' + group_server + '_node_cbs_id').append("<label for='" + node_id_group_server + "' title='Toggle node selection for " + node.node_name + "\n Country: " + node.node_country + "\n City: " + node.node_city + "\n Instance: " + node.node_sg + "'>" + node.node_name + "</label>");
                    } else {
                        if (node_grouping_options == 1) {
                            var node_groupby_label   = node.node_sg;
                            var node_groupby_class   = 'subgroupselection';
                        }
                        if (node_grouping_options == 2) {
                            var node_groupby_label   = node.node_city;
                            var node_groupby_class   = 'cityselection';
                        }   
                        if (node_grouping_options == 3) {
                            var node_groupby_label   = node.node_country;
                            var node_groupby_class   = 'countryselection';
                        }
                        // use tilde not underscores as delimiter so other code doesn't trigger off this
                        var node_groupby_group_server = node_groupby_label + "~" + group + "~" + server;
                        if($("input[type='checkbox'][id='" + node_groupby_group_server + "']").length == 0) {
                            $('#' + group_server + '_node_cbs_id').append("<label for='" + node_groupby_group_server + "' title='Toggle node selection for:\n" + node.node_name + "'>" + node_groupby_label + " <img id='cb_" + node_groupby_group_server +"_img' src='images/all.png' alt='all selected' height='10' width='10'>");
                            $('#' + group_server + '_node_cbs_id').append("<input type='checkbox' class='" + node_groupby_class + "' id='" + node_groupby_group_server + "' name='cb-" + node_groupby_group_server + "' value='" + node_id_group_server + "' onclick='selectGrouping(this)'></label>");
                        } else {
                            var my_label = $("label[for='" + node_groupby_group_server + "']").attr("title");
                            $("label[for='" + node_groupby_group_server + "']").attr("title", my_label + "\n" + node.node_name);
                            var my_cb = $("input[type='checkbox'][id='" + node_groupby_group_server + "']");
                            $.each(my_cb, function() {
                               this.value = this.value + "~" + node_id_group_server; 
                            });
                        }
                    }
                }
                if (node_grouping_options != 0) {
                    // We must sort the country, city and instances alphabetically
                    var sorted = $('#' + group_server + '_node_cbs_id label').sort(sortByText);
                    $('#' + group_server + '_node_cbs_id').append(sorted);
                }
            }
        }
    }
}

function ngChanged() {
    var active_group = $( "li.activeGpTab" );
    $.each(active_group, function() {
        var group_name = this.id.substring(3, this.id.length);
        gpTab(group_name);
    });
}

function setServersGroups() {
    // sets window.servers to the set of server names,
    // and window.groups to the set of group names.
    // nodeselection checkbox name format: 'node-id_group_server'
    window.servers = {};
    window.groups = {};
    $("input[type='checkbox'].nodeselection").each(function(){
        var s = $(this).attr('name').split('_')[2];
        var g = $(this).attr('name').split('_')[1];
        window.servers[s] = true;
        window.groups[g + "_" + s] = true;
    });
}

function selectSisterGrouping(grp_class) {
    $("input[type='checkbox']." + grp_class).each(function(){
         node_list = this.value.split("~");
         var all = true;
         var none = true;
         $.each(node_list, function(i, value){
             var node_cb = $("#" + value);
             if($(node_cb).is(':checked')){
                 none = false;
             }else{
                 all = false;
             }
         });
         if (all == true) {
             $(this).prop('checked', true);
             $("label[for='" + this.id + "']").css("color", '#000');
             document.getElementById("cb_" + this.id + "_img").src="images/all.png";
             document.getElementById("cb_" + this.id + "_img").alt="all selected";
         } else if (none == true) {
             $(this).prop('checked', false);
             $("label[for='" + this.id + "']").css("color", '#999');
             document.getElementById("cb_" + this.id + "_img").src="images/none.png";
             document.getElementById("cb_" + this.id + "_img").alt="none selected";
         } else {
             $(this).prop('checked', true);
             //$("label[for='" + this.id + "']").css("color", '#0072B2');
             $("label[for='" + this.id + "']").css("color", '#000');
             var temp = $("#cb_" + this.id + "_img");
             document.getElementById("cb_" + this.id + "_img").src="images/some.png";
             document.getElementById("cb_" + this.id + "_img").alt="some selected";
         }
     });
}


function selectSister(idList, ckd) {
    // finds all checkboxes where their node id
    // is in idList and sets their checked status
    // to ckd (true / false)
    $.each(idList, function(i, value){
        var ids = value.split('_');
        var nd = ids[0];
        var gp = ids[1];
        var srvr = ids[2];
        for(gs in window.groups){
            g = gs.split('_')[0];
            s = gs.split('_')[1];
            if((s === srvr) /* && (g !== gp)*/){
                var sisterId = nd + '_' + g + '_' + srvr;
                var sister = $("#" + sisterId);
                if(sister){
                    sister.prop('checked', ckd);
                }
            }
        }
    });
    
    // update to also set the cbs in the grouping tabs
    var grouping = ["subgroupselection", "cityselection", "countryselection"]; 
    for (i = 0; i < 3; i++) { 
        selectSisterGrouping(grouping[i]);
    }

    // set group tab images to reflect
    // whether all, some or no checkboxes
    // are selected
    initnodetabs();
}

function select(cbGp, ckd) {
    // for all checkboxes with the name cbGp
    // set checked status to ckd (true/false)
    var idList = new Array();
    $("input[type='checkbox'][name=" + cbGp + "]").each(function(){
        $(this).prop('checked', ckd);
        idList.push($(this).attr('id'));
    });
    // ensure any sister nodes are
    // updated to maintain consistency
    selectSister(idList, ckd);
}

function updateAll(ckd) {
    // for all checkboxes 
    // set checked status to ckd (true/false)
    var idList = new Array();
    $("input[type='checkbox']").each(function(){
        $(this).prop('checked', ckd);
        idList.push($(this).attr('id'));
    });
    // ensure any sister nodes are
    // updated to maintain consistency
    selectSister(idList, ckd);
}

function selectAll(cbGp) {
    // set all checkboxes with the
    // name cbGp to checked: true
    select(cbGp,true);
}

function selectNone(cbGp) {
    // set all checkboxes with the
    // name cdGp to checked: false
    select(cbGp,false);
}

function selectOnly(cbGp) {
    // set all checkboxes to false then 
	// set all with
    // name cdGp to checked: true
	updateAll(false)
    select(cbGp,true);
}


function selectNode(ckbxid) {
    // ensure any sister nodes are
    // updated to maintain consistency
    idList = new Array();
    idList.push(ckbxid);
    selectSister(idList, $("#" + ckbxid).is(':checked'));
}

function selectGrouping(item) {
    idList = item.value.split("~");
    selectSister(idList, $(item).is(':checked'));
    var my_subgroup = item.id.split("~")[0];
    var my_server   = item.id.split("~")[2];
    $("input[type='checkbox']." + item.class).each(function(){
        var this_subgroup = this.id.split("~")[0];
        var this_server = this.id.split("~")[2];
        if (my_server == this_server && my_subgroup == this_subgroup) {
            this.checked = $(item).is(':checked');
        }
    });
}

function selectSome(cbGs) {
    // determine whether all, some or no
    // checkboxes are checked where their
    // name is cbGs and then update the
    // group tab image accordingly
    var none = true;
    var all = true;
    
    $("input[type='checkbox'][name=" + cbGs + "]").each(function() {
        if($(this).is(':checked')){
            none = false;
        }else{
            all = false;
        }
    });
    
    if(none){
        $("#" + cbGs + "_img").attr("src", "images/none.png");
        $("#" + cbGs + "_img").attr("alt", "none selected"); 
    }else if(all){
        $("#" + cbGs + "_img").attr("src", "images/all.png");
        $("#" + cbGs + "_img").attr("alt", "all selected");
    }else{
        $("#" + cbGs + "_img").attr("src", "images/some.png");
        $("#" + cbGs + "_img").attr("alt", "some selected");
    }
    
}

function initnodetabs(){
    // for each group tab, set the image
    // which indicates whether all, some
    // or no checkboxes are selected

    for(var gs in window.groups) {
        selectSome('cb_' + gs);
    }
    enableGenerate(true);
}

function gpTab(gpnm) {
    // set active group tab, display associated
    // node content and hide old node content from view
    $("li.activeGpTab").removeClass("activeGpTab");
    $("#li_" + gpnm).addClass("activeGpTab");
    old_content = $(".group_showing");
    old_content.removeClass("group_showing");
    old_content.addClass("hidden");
    if ($('#ng_instance').prop('checked') === true) gpnm = gpnm + "_subgroup";
    if ($('#ng_city').prop('checked')     === true) gpnm = gpnm + "_city";
    if ($('#ng_country').prop('checked')  === true) gpnm = gpnm + "_country";
    $("#" + gpnm).removeClass("hidden");
    $("#" + gpnm).addClass("group_showing");
}

function serverTab() {
    // display associated group tabs for selected
    // server and hide old group tabs from view
    gptabsid_tmp = $("#servers option:selected").text();
    gptabsid = parse_name(gptabsid_tmp);
    old_content = $("div.server_showing");
    old_content.removeClass('server_showing');
    old_content.addClass('hidden');
    $("#" + gptabsid).removeClass('hidden');
    $("#" + gptabsid).addClass('server_showing');
    gpTab('All_' +  gptabsid);
    for(var gs in window.groups) {
        s = gs.split('_')[1];
        if(s === gptabsid){
            selectAll('cb_' + gs);
        }else{
            selectNone('cb_' + gs);
        }
        selectSome('cb_' + gs);
    }
}