$(document).ready(function() {
  $("body").on("click", "a.open-img", function(e) {
    e.preventDefault();
    var url = $(this).data("img");
    $("#imageInModal").attr("src", url);
    $("#imageModal").modal("show");
  });

  $("body").on("click", ".logo", function(e) {
    console.log("Clicked on the logo upload modal");
    $("#uploadLogoModal").modal("show");
  });
});
