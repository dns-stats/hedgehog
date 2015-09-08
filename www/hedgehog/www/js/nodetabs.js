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

function initnodehtml(output_text) {

    var nodes = [
      { server:     "Server-A",
        groups:     [{group_name: "Region-1", node_list: [{node_name: "Node-1", node_id: "1"}, {node_name: "Node-2", node_id: "2"}]},
                     {group_name: "Region-2", node_list: [{node_name: "Node-3", node_id: "3"}, {node_name: "Node-4", node_id: "4"}]}]
      },
      { server:     "L-root",
        groups:     [{group_name: "Europe",  node_list: [{node_name: "Node-5", node_id: "5"}, {node_name: "Node-6", node_id: "6"}]},
                     {group_name: "America", node_list: [{node_name: "Node-7", node_id: "7"}, {node_name: "Node-8", node_id: "8"}]}]
      }
    ];

    // Append requires a full element and will close any open elements....
    $('#nodetabs2').append("<div class='sixteen columns' id='groupcontent'></div>");
    $('#nodetabs2').append("<br class='clear'>");
    $('#nodetabs2').append("<div class='sixteen columns' id='nodecontent'>");

     // For each server, construct the groups. 
     for (var i = 0; i < nodes.length; i++) {
      $('#groupcontent').append("<div id='" + nodes[i].server +"' class='hidden'>");
            $('#' + nodes[i].server).append("<div class='Tabs' id='" + nodes[i].server +"_tabs'>");
                $('#' + nodes[i].server + '_tabs').append("<ul id='" + nodes[i].server +"_tabs_ul'>");
                for (var j = -1; j < nodes[i].groups.length; j++) {
                    if (j ==-1) var group = "All"; 
                    else        var group =  nodes[i].groups[j].group_name;
                    var group_server = group + "_" + nodes[i].server;
                    // create the top tab
                    $('#' + nodes[i].server + '_tabs_ul').append("<li id='li_" + group_server + "' onclick='gpTab(\"" + group_server + "\")'>  <a>" + group + "<img id='cb_" + group_server +"_img' src='images/all.png' alt='all selected' height='10' width='10'></a></li>");
                    // now the node content
                    $('#nodecontent').append("<div class='group_showing' id='" + group_server + "'>");
                        $('#' + group_server).append("<div class='allnone' id='" + group_server + "_allnone'>");
                            $('#' + group_server + '_allnone').append("<a style='font-weight:bold;'>Actions:</a>");
                            $('#' + group_server + '_allnone').append("<input type='button' id='selectAllBtn2'  value='Select all nodes'    title='Select all available nodes for plotting' onclick='selectAll(\"cb_" + group_server + "\")'>"); 
                            $('#' + group_server + '_allnone').append("<input type='button' id='selectNoneBtn2' value='De-select all nodes' title='De-select all available nodes'           onclick='selectNone(\"cb_" + group_server + "\")'><hr>");
                        $('#' + group_server).append(" <div class='node_cbs' id='" + group_server + "_node_cbs_id'>");
                    // FIXME: collapse loop to a single pass for all and groups
                    if (j != -1) {
                        for (var k = 0; k < nodes[i].groups[j].node_list.length; k++) {
                            var node_name = nodes[i].groups[j].node_list[k].node_name;
                            var node_id   = nodes[i].groups[j].node_list[k].node_id;
                            var node_group_server = node_id + "_" + group_server;
                            // FIXME: Format of node checkboxes is wrong
                            $('#' + group_server + '_node_cbs_id').append("<input type='checkbox' class='nodeselection' id='" + node_group_server + "' name='cb_" + group_server + "' value='" + node_group_server + "' data-node-subgroup='Subgroup-1' onclick='selectNode(\"" + node_group_server + "\")'>");
                            $('#' + group_server + '_node_cbs_id').append("<label class='' for='" + node_group_server + "' title='Toggle node selection'>" + node_name + "</label>");                                    
                        }
                    } else {
                        for (var x = 0; x < nodes[i].groups.length; x++) {
                            for (var k = 0; k < nodes[i].groups[x].node_list.length; k++) {
                                var node_name = nodes[i].groups[x].node_list[k].node_name;
                                var node_id   = nodes[i].groups[x].node_list[k].node_id;
                                var node_group_server = node_id + "_" + group_server;
                                $('#' + group_server + '_node_cbs_id').append("<input type='checkbox' class='nodeselection' id='" + node_group_server + "' name='cb_" + group_server + "' value='" + node_group_server + "' data-node-subgroup='Subgroup-1' onclick='selectNode(\"" + node_group_server + "\")'>");
                                $('#' + group_server + '_node_cbs_id').append("<label class='' for='" + node_group_server + "' title='Toggle node selection'>" + node_name + "</label>");                                    
                            }
                        }
                    }
                }
     }
}

function setServersGroups() {
    // sets window.servers to the set of server names,
    // and window.groups to the set of group names.
    // nodeselection checkbox name format: 'node_group_server'
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