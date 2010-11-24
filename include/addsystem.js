$(document).ready(function() {
    $("#addtype").click(function() {
        $("#typetd").html('<input type="text" name="type" />');
    });

    $("#addos").click(function() {
        $("#ostd").html('Name <input type="text" size="14" name="osname"/> Version <input type="text" size="5" name="osversion" />');
    });

    $("#physical").click(function() {
        $.ajax({url: "ajax/getsystemdetails.php?type=physical", success: function(data) {
            $(".systemdetails").remove();
            $("#formtable").append(data);
            addmodel();
            adddatacenter();
            addcabinet();
            refreshcabinets($("#datacenterselect").val());
        }});
    });

    $("#virtual").click(function() {
        $.ajax({url: "ajax/getsystemdetails.php?type=virtual", success: function(data) {
            $(".systemdetails").remove();
            $("#formtable").append(data);
        }});
    });

    addmodel();
    adddatacenter();
    addcabinet();
});

function addmodel() {
    $("#addmodel").click(function() {
         $("#modeltd").html('Make <input type="text" size="10" name="modelmake" /> ' +
                            'Model <input type="text" size="10" name="modelmodel" /> ' +
                            'Height <input type="text" size="2" name="modelheight" value="0" />');
    });
}

function adddatacenter() {
    $("#adddatacenter").click(function() {
        $("#datacentertd").html('Name <input type="text" size="10" name="datacentername" /> ' +
                                'Address <input type="text" size="20" name="datacenteraddress" />');
        $("#cabinettd").html('Row <input type="text" size="2" name="cabinetrow" /> ' +
                             'Column <input type="text" size="2" name="cabinetcolumn" />');
    });
    
    $("#datacenterselect").change(function() {
        refreshcabinets($("#datacenterselect").val());
    });
}

function addcabinet() {
    $("#addcabinet").click(function() {
        $("#cabinettd").html('Row <input type="text" size="2" name="cabinetrow" /> ' +
                             'Column <input type="text" size="2" name="cabinetcolumn" />');
    });
}

function refreshcabinets(datacenter) {
    $.ajax({url: "ajax/getcabinets.php?datacenter=" + datacenter, success: function(data) {
        $("#cabinettd").html(data);
        addcabinet();
    }});
}
