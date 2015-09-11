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

function initNodeHtml(nodes_raw) {

    // FIX ME: This doesn't yet work or sub-group, country or city
    
    // Example data format
    // var nodes = [
    //   { server:     "Server-A",
    //     groups:     [{group_name: "Region-1", node_list: [{node_name: "Node-1", node_id: "1"}, {node_name: "Node-2", node_id: "2"}]},
    //                  {group_name: "Region-2", node_list: [{node_name: "Node-3", node_id: "3"}, {node_name: "Node-4", node_id: "4"}]}]},
    //   { server:     "L-root",
    //     groups:     [{group_name: "Europe",  node_list: [{node_name: "Node-5", node_id: "5"}, {node_name: "Node-6", node_id: "6"}]},
    //                  {group_name: "America", node_list: [{node_name: "Node-7", node_id: "7"}, {node_name: "Node-8", node_id: "8"}]}]}];

    nodes= jQuery.parseJSON(nodes_raw);
    // TODO: Check for errors e.g. empty data

    // Append requires a full element and will close any open elements so need care when using it.
    $('#nodetabs').append("<div class='sixteen columns' id='groupcontent'></div>");
    $('#nodetabs').append("<br class='clear'>");
    $('#nodetabs').append("<div class='sixteen columns' id='nodecontent'>");
    $('#srvr_select').append("<a style='font-weight:bold; font-size:80%; text-decoration: none; padding-left: 20px; padding-right: 5px;'>Group by:</a>");
    $('#srvr_select').append("<input type='radio'          id='ng_subgroup' name='node_grouping' onclick='ngChanged()' >  <label style='font-weight:bold;' for='ng_subgroup' >Sub-group</label>");
    $('#srvr_select').append("<input type='radio'          id='ng_none'     name='node_grouping' onclick='ngChanged()' ><label style='font-weight:bold;' for='ng_none'     >None</label>");

    // For each server, construct the groups.
    for (var i = 0; i < nodes.length; i++) {
        $('#groupcontent'                ).append(  "<div class='hidden' id='" + nodes[i].server + "'>");
        $('#' + nodes[i].server          ).append(  "<div class='Tabs'   id='" + nodes[i].server + "_tabs'>");
        $('#' + nodes[i].server + '_tabs').append(  "<ul                 id='" + nodes[i].server +"_tabs_ul'>");
        // For each group, add a tab and fill in the nodes
        for (var j = -1; j < nodes[i].groups.length; j++) {
            // Special case for the 'All' tabs are needed here
            if (j == -1) var group = "All"; 
            else         var group =  nodes[i].groups[j].group_name;
            // TODO: improve names
            var group_server       = group + "_" + nodes[i].server;
            var group_server_basic = group_server;
            // Create the top tab with a list entry
            $('#' + nodes[i].server + '_tabs_ul').append("<li id='li_" + group_server + "' onclick='gpTab(\"" + group_server + "\")'>  <a>" + group + "<img id='cb_" + group_server +"_img' src='images/all.png' alt='all selected' height='10' width='10'></a></li>");
            //Now the node content divs
            for (var node_grouping_options = 0; node_grouping_options <=1;node_grouping_options++) {
                if (node_grouping_options == 1) group_server = group_server + "_subgroup";
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
                // Add all the nodes to the 'All' tab or just the group nodes for all other cases
                if (j == -1) {var start_group = 0; var stop_group = nodes[i].groups.length; }
                else         {var start_group = j; var stop_group  = j + 1}
                // Loop over the groups/nodes
                for (var x = start_group; x < stop_group; x++) {
                    for (var k = 0; k < nodes[i].groups[x].node_list.length; k++) {
                        var node_name            = nodes[i].groups[x].node_list[k].node_name;
                        var node_id              = nodes[i].groups[x].node_list[k].node_id;
                        var node_sg              = nodes[i].groups[x].node_list[k].node_sg;
                        // TODO[node grouping]: this will need special handling on select......
                        if (!node_sg) node_sg    = 'Other';
                        var node_id_group_server = node_id + "_" + group_server;

                        // use tilde not underscores so current code doesn't trigger off this
                        var node_sg_group_server = node_sg + "~" + group + "~" + nodes[i].server;
                        if (node_grouping_options == 0) {
                            $('#' + group_server + '_node_cbs_id').append("<input type='checkbox' class='nodeselection' id='" + node_id_group_server + "' name='cb_" + group_server + "' onclick='selectNode(\"" + node_id_group_server + "\")'>");
                            $('#' + group_server + '_node_cbs_id').append("<label for='" + node_id_group_server + "' title='Toggle node selection'>" + node_name + "</label>");
                        } else {
                            if($("input[type='checkbox'][id='" + node_sg_group_server + "']").length == 0) {
                                $('#' + group_server + '_node_cbs_id').append("<input type='checkbox' class='subgroubselection' id='" + node_sg_group_server + "' name='cb-" + node_sg_group_server + "' value='" + node_id_group_server + "' onclick='selectSubGroup(this)'>");
                                $('#' + group_server + '_node_cbs_id').append("<label for='" + node_sg_group_server + "' title='Toggle node selection for:\n" + node_name + "'>" + node_sg + "</label>");
                            } else {
                                var my_label = $("label[for='" + node_sg_group_server + "']").attr("title");
                                $("label[for='" + node_sg_group_server + "']").attr("title", my_label + "\n" + node_name);
                                var my_cb = $("input[type='checkbox'][id='" + node_sg_group_server + "']");
                                $.each(my_cb, function() {
                                   this.value = this.value + "~" + node_id_group_server; 
                                });
                            }
                        }
                    }
                }
            }
        }
    }
    // Enable all subgroups by default
    $("input[type='checkbox'].subgroubselection").each(function(){
        this.checked = true;
    });
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
    
    //TODO[node_grouping]: update this to also set the cbs in the grouping tabs
    
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

function selectSubGroup(subgroup) {
    //console.log("Passing this: "+ subgroup.value + " " + $(subgroup).is(':checked'));
    idList = subgroup.value.split("~");
    selectSister(idList, $(subgroup).is(':checked'));
    var my_subgroup = subgroup.id.split("~")[0];
    var my_server   = subgroup.id.split("~")[2];
    $("input[type='checkbox'].subgroubselection").each(function(){
        var this_subgroup = this.id.split("~")[0];
        var this_server = this.id.split("~")[2];
        if (my_server == this_server && my_subgroup == this_subgroup) {
            this.checked = $(subgroup).is(':checked');
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
    if ($('#ng_subgroup').prop('checked') === true) gpnm = gpnm + "_subgroup";
    $("#" + gpnm).removeClass("hidden");
    $("#" + gpnm).addClass("group_showing");
}

function serverTab() {
    // display associated group tabs for selected
    // server and hide old group tabs from view
    gptabsid = $("#servers option:selected").text();
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