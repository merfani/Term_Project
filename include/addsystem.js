$(document).ready(function() {
    $("#addtype").click(function() {
        $("#typetd").html('<input type="text" name="type" />');
    });

    $("#addos").click(function() {
        $("#ostd").html('Name <input type="text" name="osname"/> Version <input type="text" name="osversion" />');
    });
});
