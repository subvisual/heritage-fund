window.fileUploadHandlingHooks = function() {

  /**
   * Listens for the initialisation of a Rails direct upload
   * @param {Event} event - A specific Event instance
   */
  addEventListener("direct-upload:initialize", function(event) {

    var id = event.detail.id;
    var file = event.detail.file;

    event.target.insertAdjacentHTML(
      "beforebegin",
      '<div id="direct-upload-'
        .concat(
          id,
          '" class="direct-upload direct-upload--pending">\n            <div id="direct-upload-progress-'
        )
        .concat(
          id,
          '" class="direct-upload__progress" style="width: 0%"></div>\n            <span class="direct-upload__filename">'
        )
        .concat(file.name, "</span>\n          </div>")
    );

  });

  var errorMessage = {

    /**
     * Function to orchestrate error-handling for file upload input fields
     * where an error has occured during file upload
     */
    show: function show() {

      // Creates the red-outlined summary errors section at the top of the page
      createSummaryErrorsSkeleton();

      // Find the element with a unique data-input-identifier attribute, so that
      // we can dynamically distinguish between different form pages with file uploads
      var fileElement = document.querySelectorAll('[data-input-identifier=file]')[0];

      // Adds an individual error message to the summary errors section which
      // links to the file upload input field
      addSummaryError(
          false,
          fileElement.getAttribute('data-attribute'),
          "The upload of this file has failed",
          fileElement.getAttribute('data-model')
      );

      // Retrieves the 'govuk-form-group' div element which contains the
      // file upload input field
      var fileFormGroupElement = document.querySelectorAll('[data-form-group=file]')[0];

      // Adds an error message and red outline to the div element
      addFormGroupError(
        fileFormGroupElement.getAttribute('id'),
        "form-group-errors",
        fileElement.getAttribute('data-attribute'),
        "The upload of this file has failed",
        fileElement.getAttribute('data-model'),
        // If parent model identifier if present then also pass this as an argument
        fileElement.getAttribute('data-parent-model') ? fileElement.getAttribute('data-parent-model') : undefined
      );

    }

  };

  /**
   * Listens for the start of a Rails direct upload event
   * @param {Event} event - A specific Event instance
   */
  addEventListener("direct-upload:start", function(event) {

    var element = document.getElementById(
      "direct-upload-".concat(
        event.detail.id
      )
    );

    element.classList.remove("direct-upload--pending");

  });

  /**
   * Listens for the progress of a Rails direct upload event
   * and updates the direct upload progress bar
   * @param {Event} event - A specific Event instance
   */
  addEventListener("direct-upload:progress", function(event) {

    var progressElement = document.getElementById(
      "direct-upload-progress-".concat(
        event.detail.id
      )
    );

    progressElement.style.width = "".concat(
      event.detail.progress,
      "%"
    );

  });

  /**
   * Listens for any AJAX errors occuring on form submission
   * @param {XMLHttpRequest} xhr - An instance of XMLHttpRequest
   */
  addEventListener("ajax:error", function(xhr) {
    errorMessage.show();
  });

  /**
   * Listens for any Rails direct upload errors
   * @param {Event} event - A specific Event instance
   */
  addEventListener("direct-upload:error", function(event) {

    // This prevents the default functionality of displaying an alert
    event.preventDefault();

    var element = document.getElementById(
      "direct-upload-".concat(
        event.detail.id
      )
    );

    element.classList.add("direct-upload--error");

    errorMessage.show();

  });

  /**
   * Listens for the Rails direct upload end signal
   * @param {Event} event - A specific Event instance
   */
  addEventListener("direct-upload:end", function(event) {

    var element = document.getElementById(
      "direct-upload-".concat(
        event.detail.id
      )
    );

    element.classList.add("direct-upload--complete");

  });

}
