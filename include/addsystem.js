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
        }});
    });

    $("#virtual").click(function() {
        $.ajax({url: "ajax/getsystemdetails.php?type=virtual", success: function(data) {
            $(".systemdetails").remove();
            $("#formtable").append(data);
        }});
    });
});
