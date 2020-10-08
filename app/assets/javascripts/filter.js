var Filter = {
  sortBy: null,
  sortOrder: "",

  init: function () {
    $(document).ready(function () {
      $(document).on("click", ".sortable-column", function () {
        Filter.updateSort(this);
        Filter.submit();
      });

      $(document).on("keyup", "#keyword-input", function (event) {
        Filter.submit();
      });

      $(document).on("focusin", "#keyword-input", function (event) {
        this.selectionStart = this.selectionEnd = this.value.length;
      });

      $(document).on("change", "#people_csv", function (event) {
        $("#csv-submit-button").prop("disabled", false);
      });

      Filter.initSort();
      Filter.focusOnKeyword();
    });
  },

  submit: function () {
    $("form[class*='simple_form new_api_control']").submit();
  },

  updateSort: function (_this) {
    let columnName = $(_this).data("column-name");

    if (Filter.sortBy !== columnName) {
      Filter.sortBy = columnName;
      Filter.sortOrder = "";
    } else {
      Filter.sortOrder = Filter.sortOrder === "" ? "-" : "";
    }

    $("#sort-by-input").val(`${Filter.sortOrder}${Filter.sortBy}`);
  },

  focusOnKeyword: function () {
    document.getElementById("keyword-input").focus();
  },

  initSort: function () {
    let sort = $("#sort-by-input").val();
    Filter.sortOrder = sort.includes("-") ? "-" : "";
    Filter.sortBy = sort.replaceAll("-", "");
    let orderSymbol = Filter.sortOrder === "-" ? "▼" : "▲";

    if (Filter.sortBy) {
      let sortField = $(
        `.sortable-column[data-column-name='${Filter.sortBy}']`
      );
      sortField.text(`${sortField.text()}${orderSymbol}`);
    }
  },
};
