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
            var group_server       = group + "_" + nodes[i].server;
            // Create the top tab with a list entry
            $('#' + nodes[i].server + '_tabs_ul').append("<li id='li_" + group_server + "' onclick='gpTab(\"" + group_server + "\")'>  <a>" + group + "<img id='cb_" + group_server +"_img' src='images/all.png' alt='all selected' height='10' width='10'></a></li>");
            // Now the node content divs
            $('#nodecontent'                 ).append("<div class='group_showing'   id='" + group_server + "'>");
            $('#' + group_server             ).append("<div class='allnone'         id='" + group_server + "_allnone'>");
            $('#' + group_server             ).append("<div class='node_cbs'        id='" + group_server + "_node_cbs_id'>");
            // Selection buttons
            $('#' + group_server + '_allnone').append("<a style='font-weight:bold;'>Actions:</a>");
            $('#' + group_server + '_allnone').append("<input type='button'         id='selectAllBtn2'  value='Select all nodes'    title='Select all available nodes for plotting' onclick='selectAll(\"cb_" + group_server + "\")'>"); 
            $('#' + group_server + '_allnone').append("<input type='button'         id='selectNoneBtn2' value='De-select all nodes' title='De-select all available nodes'           onclick='selectNone(\"cb_" + group_server + "\")'><hr>");            
            // Add all the nodes to the 'All' tab or just the group nodes for all other cases
            if (j == -1) {var start_group = 0; var stop_group = nodes[i].groups.length; }
            else         {var start_group = j; var stop_group  = j + 1}
            // Loop over the nodes
            for (var x = start_group; x < stop_group; x++) {
                for (var k = 0; k < nodes[i].groups[x].node_list.length; k++) {
                    var node_name            = nodes[i].groups[x].node_list[k].node_name;
                    var node_id              = nodes[i].groups[x].node_list[k].node_id;
                    var node_id_group_server = node_id + "_" + group_server;
                    // FIXME: For some reason the checkboxes are not inheriting the correct class so their appearance is incorrect.
                    // FIXME: subgroup is still hardcoded. I think we could dispense with name and just use id
                    $('#' + group_server + '_node_cbs_id').append("<input type='checkbox' class='nodeselection' id='" + node_id_group_server + "' name='cb_" + group_server + "' data-node-subgroup='Subgroup-1' onclick='selectNode(\"" + node_id_group_server + "\")'>");
                    $('#' + group_server + '_node_cbs_id').append("<label class='' for='" + node_id_group_server + "' title='Toggle node selection'>" + node_name + "</label>");
                }
            }
        }
    }
}

function setServersGroups() {
    // sets window.servers to the set of server names,
    // and window.groups to the set of group names.
    // nodeselection checkbox name format: 'node_id_group_server'
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
            if((s === srvr) && (g !== gp)){
                var sisterId = nd + '_' + g + '_' + srvr;
                var sister = $("#" + sisterId);
                if(sister){
                    sister.prop('checked', ckd);
                }
            }
        }
    });
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

function collapseNodes() {

    // switch to the subgroup node view....
    // alert("Hello");
	// sync cb across all tabs
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
	if($("input[id='groupNodes']").is(':checked')){
		x = document.getElementById(ckbxid).getAttribute('data-node-subgroup');
		y = $("[data-node-subgroup='" + x + "']").map(function () {
			idList.push($(this).attr('id'));
		});
	}
	idList.push(ckbxid);
    selectSister(idList, $("#" + ckbxid).is(':checked'));
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