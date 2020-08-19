require('../../../app/javascript/file-upload-handling/index.js');
require('../../../app/javascript/error-handling/index.js');

describe('file-upload-handling test suite', () => {
  
  /**
  * We clear the document contents - otherwise it persists between tests. 
  * We clear all mocks, otherwise they persist between tests
  */
  afterEach(() => {
    document.getElementsByTagName('html')[0].innerHTML = '';
    jest.clearAllMocks();
  });

  test('direct-upload:initialize eventListener should add relevant HTML to the DOM', () => {

    var spy = jest.spyOn(window, 'addEventListener');

    var testElement = document.createElement('div');
    document.body.appendChild(testElement);

    var mockEvent = new CustomEvent(
      'direct-upload:initialize',
      // Setting bubbles equal to true ensures that the event bubbles up to
      // the window object. Not setting this means that the event will not
      // bubble and therefore the eventListener will not detect it
      { detail: { id: 1, file: { name: 'test' } }, bubbles: true }
    );

    window.fileUploadHandlingHooks();

    assertEventListenersAdded(spy);

    testElement.dispatchEvent(mockEvent);

    var directUploadProgressElement = document.getElementById('direct-upload-progress-1');
    expect(directUploadProgressElement).not.toBeNull();
    expect(directUploadProgressElement.classList.contains('direct-upload__progress')).toEqual(true);
    expect(directUploadProgressElement.getAttribute('style')).toEqual('width: 0%');

    var directUploadElement = document.getElementById('direct-upload-1');
    expect(directUploadElement).not.toBeNull();
    expect(directUploadElement.classList.contains('direct-upload')).toEqual(true);
    expect(directUploadElement.classList.contains('direct-upload--pending')).toEqual(true);
    expect(directUploadElement.children[1].classList.contains('direct-upload__filename')).toEqual(true);
    expect(directUploadElement.children[1].innerHTML).toEqual('test');

  });

  test('direct-upload:start eventListener should remove the direct-upload--pending class', () => {

    var spy = jest.spyOn(window, 'addEventListener');

    var mockEvent = new CustomEvent(
      'direct-upload:start',
      { detail: { id: 1 } }
    );

    var testElement = document.createElement('div');
    testElement.setAttribute('id', 'direct-upload-' + mockEvent.detail.id);
    testElement.classList.add('direct-upload--pending')
    document.body.appendChild(testElement);

    window.fileUploadHandlingHooks();

    assertEventListenersAdded(spy);

    window.dispatchEvent(mockEvent);

    expect(testElement.classList.contains('direct-upload--pending')).toEqual(false);
    
  });

  test('direct-upload:progress eventListener should update width style', () => {

    var spy = jest.spyOn(window, 'addEventListener');

    var mockEvent = new CustomEvent(
      'direct-upload:progress',
      { detail: { id: 1, progress: 50 } }
    );

    var testElement = document.createElement('div');
    testElement.setAttribute('id', 'direct-upload-progress-' + mockEvent.detail.id);
    testElement.style.width = '10%';
    document.body.appendChild(testElement);

    window.fileUploadHandlingHooks();

    assertEventListenersAdded(spy);

    window.dispatchEvent(mockEvent);

    expect(testElement.style.width).toEqual('50%');
    
  });

  test('direct-upload:end eventListener should add the direct-upload--complete class', () => {

    var spy = jest.spyOn(window, 'addEventListener');

    var mockEvent = new CustomEvent(
      'direct-upload:end',
      { detail: { id: 1 } }
    );

    var testElement = document.createElement('div');
    testElement.setAttribute('id', 'direct-upload-' + mockEvent.detail.id);
    document.body.appendChild(testElement);

    window.fileUploadHandlingHooks();

    assertEventListenersAdded(spy);

    window.dispatchEvent(mockEvent);

    expect(testElement.classList.contains('direct-upload--complete')).toEqual(true);
    
  });

  test('ajax:error eventListener should render the appropriate error message (no data-parent-model attribute)', () => {

    var spy = jest.spyOn(window, 'addEventListener');

    var mockEvent = new CustomEvent(
      'ajax:error',
      { detail: { id: 1 } }
    );

    createSkeletonHTML();

    window.fileUploadHandlingHooks();

    assertEventListenersAdded(spy);

    window.dispatchEvent(mockEvent);

    assertErrors(0);
    
  });

  test('ajax:error eventListener should render the appropriate error message (with data-parent-model attribute)', () => {

    var spy = jest.spyOn(window, 'addEventListener');

    var mockEvent = new CustomEvent(
      'ajax:error',
      { detail: { id: 1 } }
    );

    createSkeletonHTML('parentModel');

    window.fileUploadHandlingHooks();

    assertEventListenersAdded(spy);

    window.dispatchEvent(mockEvent);

    assertErrors(0);
    
  });

  test('direct-upload:error eventListener should render the appropriate error message (no data-parent-model attribute)', () => {

    var spy = jest.spyOn(window, 'addEventListener');

    var mockEvent = new CustomEvent(
      'direct-upload:error',
      { detail: { id: 1 } }
    );

    var preventDefaultSpy = jest.spyOn(mockEvent, 'preventDefault');

    createSkeletonHTML();

    var testElement = document.createElement('div');
    testElement.setAttribute('id', 'direct-upload-' + mockEvent.detail.id);
    document.body.appendChild(testElement);

    window.fileUploadHandlingHooks();

    assertEventListenersAdded(spy);

    window.dispatchEvent(mockEvent);

    expect(
      document.getElementById('direct-upload-1').classList.contains('direct-upload--error')
    ).toEqual(true);

    expect(preventDefaultSpy).toBeCalled();

    assertErrors(0);

  });

  test('direct-upload:error eventListener should render the appropriate error message (with data-parent-model attribute)', () => {

    var spy = jest.spyOn(window, 'addEventListener');

    var mockEvent = new CustomEvent(
      'direct-upload:error',
      { detail: { id: 1 } }
    );

    var preventDefaultSpy = jest.spyOn(mockEvent, 'preventDefault');

    createSkeletonHTML('parentModel');

    var testElement = document.createElement('div');
    testElement.setAttribute('id', 'direct-upload-' + mockEvent.detail.id);
    document.body.appendChild(testElement);

    window.fileUploadHandlingHooks();

    assertEventListenersAdded(spy);

    window.dispatchEvent(mockEvent);

    expect(
      document.getElementById('direct-upload-1').classList.contains('direct-upload--error')
    ).toEqual(true);

    expect(preventDefaultSpy).toBeCalled();

    assertErrors(0);

  });

});

/**
 * Function to create skeleton HTML structure required
 * for the errorMessage.show() function call to
 * run as intended
 * @param {String} parentModel - a parent model name
 */
function createSkeletonHTML(parentModel) {

  var summaryErrorsElement = document.createElement('div');
  summaryErrorsElement.setAttribute('id', 'summary-errors');

  var summaryErrorsList = document.createElement('ul');
  summaryErrorsList.setAttribute('id', 'summary-errors-list');

  summaryErrorsElement.appendChild(summaryErrorsList);

  var formGroupElement = document.createElement('div');
  formGroupElement.setAttribute('data-form-group', 'file');
  formGroupElement.setAttribute('id', 'formGroup');

  var formGroupErrorsElement = document.createElement('div');
  formGroupErrorsElement.setAttribute('id', 'form-group-errors');

  formGroupElement.appendChild(formGroupErrorsElement);

  var fileElement = document.createElement('input');
  fileElement.setAttribute(
    'id', parentModel ? 'parentModel_model_attributes_0_attribute_file' : 'model_attribute_file'
  );
  fileElement.setAttribute('data-input-identifier', 'file');
  fileElement.setAttribute('data-attribute', 'attribute_file');
  fileElement.setAttribute('data-model', 'model');
  if (parentModel)
    fileElement.setAttribute('data-parent-model', 'parentModel');

  formGroupElement.appendChild(fileElement);

  document.body.appendChild(summaryErrorsElement);
  document.body.appendChild(formGroupElement);

}

/**
 * Reusable function to assert that addEventListener has been called
 * for each event type expected by the fileUploadHandlingHooks function
 * @param {Spy} spy - An instance of a Jest Spy object 
 */
function assertEventListenersAdded(spy) {

  // addEventListener is called each time with a second argument containing
  // an anonymous function. We're unable to pass in an anonymous function
  // in our assertion, as the test will perform an object comparison and fail
  expect(spy.mock.calls).toEqual(
    [
      ['direct-upload:initialize', expect.any(Function)],
      ['direct-upload:start', expect.any(Function)],
      ['direct-upload:progress', expect.any(Function)],
      ['ajax:error', expect.any(Function)],
      ['direct-upload:error', expect.any(Function)],
      ['direct-upload:end', expect.any(Function)]
    ]
  );

}

/**
 * Reusable function to assert expectations common across multiple tests
 * @param {int} listItemIndex - An integer denoting a specific <li> index within a <ul>
 */
function assertErrors(listItemIndex) {

  var summaryErrorsElement = document.getElementById('summary-errors');
  expect(summaryErrorsElement.classList.contains('govuk-error-summary')).toEqual(true);
  expect(summaryErrorsElement.getAttribute('role')).toEqual('alert');
  expect(summaryErrorsElement.getAttribute('tabindex')).toEqual('-1');
  expect(summaryErrorsElement.getAttribute('data-module')).toEqual('govuk-error-summary');

  var summaryErrorsTitle = document.getElementById('error-summary-title');
  expect(summaryErrorsTitle).not.toBeNull();
  expect(summaryErrorsTitle.classList.contains('govuk-error-summary__title')).toEqual(true);
  expect(summaryErrorsTitle.innerText).toEqual('There is a problem');

  var summaryErrorsList = document.getElementById('summary-errors-list');
  expect(summaryErrorsList).not.toBeNull();
  expect(summaryErrorsList.children[listItemIndex].innerHTML).toEqual(
    '<a data-turbolinks="false" href="#project_capital_work_true"></a>'
  );
  expect(summaryErrorsList.children[listItemIndex].firstChild.innerText).toEqual(
    'The upload of this file has failed'
  );

  var formGroupErrorsElement = document.getElementById('form-group-errors');
  expect(formGroupErrorsElement).not.toBeNull();
  expect(formGroupErrorsElement.firstChild.innerHTML).toEqual(
    '<span class="govuk-visually-hidden">Error: </span>The upload of this file has failed'
  );

  var fileElement = document.querySelectorAll('[data-input-identifier=file]')[0];
  expect(fileElement.classList.contains('govuk-file-upload--error'))

}
