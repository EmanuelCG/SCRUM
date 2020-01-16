$(document).ready(function() {

    $("#btn-grid").click(function() {
        $(".list").hide();
        $(".grid").show();

    });

    $("#btn-list").click(function() {
        $(".grid").hide();
        $(".list").show();
    });
});
