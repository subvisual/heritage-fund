





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

function createSummaryErrorsHeading() {
    var summaryErrorsHeading = document.createElement("h2");
    summaryErrorsHeading.classList.add("govuk-error-summary__title");
    summaryErrorsHeading.setAttribute("id", "error-summary-title");
    summaryErrorsHeading.innerText = "There is a problem";

    return summaryErrorsHeading;
}

function createSummaryErrorsBody() {
    var summaryErrorsBodyElement = document.createElement("div");
    summaryErrorsBodyElement.classList.add("govuk-error-summary__body");

    return summaryErrorsBodyElement;
}

function createSummaryErrorsList() {
    var summaryErrorsList = document.createElement("ul");
    summaryErrorsList.setAttribute("id", "summary-errors-list");
    summaryErrorsList.classList.add("govuk-list")
    summaryErrorsList.classList.add("govuk-error-summary__list");

    return summaryErrorsList;
}

function createAndAppendListItem(summaryErrorsList, message, attribute) {
    var listItemElement = document.createElement("li");
    var linkElement = document.createElement("a");

    linkElement.setAttribute("data-turbolinks", "false");
    linkElement.setAttribute("href", attribute === "capital_work" ?
        "#project_capital_work_false" : "#project_capital_work_true");
    linkElement.innerText = "test";

    listItemElement.appendChild(linkElement);
    summaryErrorsList.appendChild(listItemElement);
}

function addError(
    summaryErrorsElement, summaryErrorsList,
    isNestedForm, attribute, message, modelName) {

    if (summaryErrorsElement.innerHTML.includes(message) === false
        && attribute !== modelName) {

        createAndAppendListItem(summaryErrorsList, message, attribute);

    }

}