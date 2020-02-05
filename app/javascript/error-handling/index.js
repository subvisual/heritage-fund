/*
  Function used to create the skeleton code for the GOV.UK-styled
  summary errors element
 */
window.createSummaryErrorsSkeleton = function() {

    var summaryErrorsElement = document.getElementById("summary-errors");

    addSummaryErrorsClassAndAttributes(summaryErrorsElement);

    if (summaryErrorsElement.innerHTML.includes("h2") === false) {
        summaryErrorsElement.appendChild(createSummaryErrorsHeading());
    }

    if (summaryErrorsElement.innerHTML.includes("div") === false) {
        var summaryErrorsBodyElement = createSummaryErrorsBody();
        summaryErrorsElement.appendChild(summaryErrorsBodyElement);
    } else {
        summaryErrorsBodyElement =
            document.getElementById("summary-errors-body");
    }

    if (summaryErrorsElement.innerHTML.includes("ul") === false) {
        var summaryErrorsList = createSummaryErrorsList();
        summaryErrorsBodyElement.appendChild(summaryErrorsList);
    } else {
        summaryErrorsList = document.getElementById("summary-errors-list");
        summaryErrorsList.innerHTML = "";
    }

}

/*
  Function to create the GOV.UK-styled summary errors element
 */
function addSummaryErrorsClassAndAttributes(summaryErrorsElement) {

    // Only add the govuk-error-summary class if it does not already exist
    if (summaryErrorsElement.classList.contains("govuk-error-summary") === false) {
        summaryErrorsElement.classList.add("govuk-error-summary");
    }

    summaryErrorsElement.setAttribute("aria-labelledby", "error-summary-title");
    summaryErrorsElement.setAttribute("role", "alert");
    summaryErrorsElement.setAttribute("tabindex", "-1");
    summaryErrorsElement.setAttribute("data-module", "govuk-error-summary");

}

/*
  Function to create the heading for the GOV.UK-styled summary errors element
 */
function createSummaryErrorsHeading() {

    var summaryErrorsHeading = document.createElement("h2");

    summaryErrorsHeading.classList.add("govuk-error-summary__title");

    summaryErrorsHeading.setAttribute("id", "error-summary-title");

    summaryErrorsHeading.innerText = "There is a problem";

    return summaryErrorsHeading;

}

/*
  Function to create the body for the GOV.UK-styled summary errors element
 */
function createSummaryErrorsBody() {

    var summaryErrorsBodyElement = document.createElement("div");

    summaryErrorsBodyElement.classList.add("govuk-error-summary__body");

    summaryErrorsBodyElement.setAttribute("id", "summary-errors-body");

    return summaryErrorsBodyElement;

}

/*
  Function to create the list for the GOV.UK-styled summary errors element
 */
function createSummaryErrorsList() {

    var summaryErrorsList = document.createElement("ul");

    summaryErrorsList.setAttribute("id", "summary-errors-list");

    summaryErrorsList.classList.add("govuk-list")
    summaryErrorsList.classList.add("govuk-error-summary__list");

    return summaryErrorsList;

}

/*
  Function to create a list item and append it to the existing list
  within the GOV.UK-styled summary errors element
 */
function createAndAppendListItem(message, attribute, modelName) {

    var summaryErrorsList = document.getElementById("summary-errors-list");

    var listItemElement = document.createElement("li");
    var linkElement = document.createElement("a");

    linkElement.setAttribute("data-turbolinks", "false");

    if (attribute.includes(".")) {

        var nestedModelName = attribute.split(".")[0];
        var fieldName = attribute.split(".")[1];

        // Specific to the Cash contributions page
        if (fieldName === "secured")
            fieldName += "_yes_with_evidence";

        linkElement.setAttribute(
            "href",
            "#" + modelName + "_" + nestedModelName + "_attributes_0_" + fieldName);

    } else {

        // Specific to the Capital work page
        linkElement.setAttribute("href", attribute === "capital_work" ?
            "#project_capital_work_false" : "#project_capital_work_true");

    }

    linkElement.innerText = message;

    listItemElement.appendChild(linkElement);
    summaryErrorsList.appendChild(listItemElement);

}


window.addSummaryError = function(isNestedForm, attribute, message,
                                  modelName, childModelName) {

    var summaryErrorsElement = document.getElementById("summary-errors");

    if (summaryErrorsElement.innerHTML.includes(message) === false
        && attribute !== childModelName) {

        createAndAppendListItem(
            message,
            attribute,
            modelName
        );

    }

}
