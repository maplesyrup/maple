$(document).ready(function() {
  $("body").on("click", "a.open-img", function(e) {
    e.preventDefault();
    var url = $(this).data("img");
    $("#imageInModal").attr("src", url);
    $("#imageModal").modal("show");
  });
});
