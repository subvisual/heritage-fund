const { default: CookieBanner } = require('../../../app/javascript/cookie-banner/cookie-banner');
import * as cookieFunctionsModule from '../../../app/javascript/cookie-banner/cookie-functions.js';

require ('cookie-banner.js');

describe('cookie-banner test suite', () => {
  
  /**
  * We clear the document contents - otherwise it persists between tests. 
  * We clear all mocks, otherwise they persist between tests
  */
  afterEach(() => {
    document.getElementsByTagName('html')[0].innerHTML = '';
    document.cookie.split(';').forEach(function(c) {
    document.cookie = c.trim().split('=')[0] + '=;' + 'expires=Thu, 01 Jan 1970 00:00:00 UTC;';
    });
    window.gon = { global: { env: 'development' } };
    jest.clearAllMocks();
  });

  test('CookieBanner.prototype.init initialises by calling the correct methods', () => {

    var testElement = document.createElement('div');
    document.body.appendChild(testElement);

    var cookieBanner = new CookieBanner(testElement);

    var hideCookieMessageSpy = jest.spyOn(cookieBanner.hideCookieMessage, 'bind');
    var showConfirmationMessageSpy = jest.spyOn(cookieBanner.showConfirmationMessage, 'bind');
    var setCookieConsentSpy = jest.spyOn(cookieBanner.setCookieConsent, 'bind');
    var setupCookieMessageSpy = jest.spyOn(cookieBanner, 'setupCookieMessage');

    cookieBanner.init(testElement);

    expect(hideCookieMessageSpy).toBeCalledTimes(1);
    expect(showConfirmationMessageSpy).toBeCalledTimes(1);
    expect(setCookieConsentSpy).toBeCalledTimes(1);
    expect(setupCookieMessageSpy).toBeCalledTimes(1);

  });

  test('CookieBanner.prototype.setupCookieMessage adds event listeners appropriately', () => {

    var dataHideCookieBannerElement = document.createElement('button');
    dataHideCookieBannerElement.setAttribute('id', 'test')
    dataHideCookieBannerElement.setAttribute('data-hide-cookie-banner', true);

    var dataAcceptCookiesTrueElement = document.createElement('button');
    dataAcceptCookiesTrueElement.setAttribute('data-accept-cookies', true);

    var dataAcceptCookiesFalseElement = document.createElement('button');
    dataAcceptCookiesFalseElement.setAttribute('data-accept-cookies', false);

    document.body.appendChild(dataHideCookieBannerElement);
    document.body.appendChild(dataAcceptCookiesTrueElement);
    document.body.appendChild(dataAcceptCookiesFalseElement);

    var cookieBanner = new CookieBanner(document.body);

    cookieBanner.$module.hideCookieMessage = jest.fn().mockImplementation(() => { return 'test' });
    cookieBanner.$module.setCookieConsent = jest.fn().mockImplementation(() => { return 'test' })

    var hideLinkEventListener = jest.spyOn(dataHideCookieBannerElement, 'addEventListener');
    var acceptCookiesLinkEventListener = jest.spyOn(dataAcceptCookiesTrueElement, 'addEventListener');
    var rejectCookiesLinkEventListener = jest.spyOn(dataAcceptCookiesFalseElement, 'addEventListener');
    var showCookieMessageSpy = jest.spyOn(cookieBanner, 'showCookieMessage');

    cookieBanner.setupCookieMessage();

    expect(hideLinkEventListener.mock.calls).toEqual(
      [
        ['click', expect.any(Function)]
      ]
    )
    expect(acceptCookiesLinkEventListener.mock.calls).toEqual(
      [
        ['click', expect.any(Function)]
      ]
    )
    expect(rejectCookiesLinkEventListener.mock.calls).toEqual(
      [
        ['click', expect.any(Function)]
      ]
    )

    expect(showCookieMessageSpy).toBeCalledTimes(1);


  });

  test('CookieBanner.prototype.showCookieMessage sets display to block if conditions are met', () => {

    // Mock getCookie so that cookie policy cookie is not found
    jest.mock('../../../app/javascript/cookie-banner/cookie-functions.js');
    cookieFunctionsModule.getCookie = jest.fn().mockImplementation(
      () => { return false }
    );

    var testElement = document.createElement('div');
    testElement.style.display = 'none';
    document.body.appendChild(testElement);

    var cookieBanner = new CookieBanner(testElement);

    cookieBanner.showCookieMessage();

    expect(testElement.style.display).toEqual('block');

  });

  test('CookieBanner.prototype.showCookieMessage does not set display to block if no module exists', () => {

    // Mock getCookie so that cookie policy cookie is not found
    jest.mock('../../../app/javascript/cookie-banner/cookie-functions.js');
    cookieFunctionsModule.getCookie = jest.fn().mockImplementation(
      () => { return false }
    );

    var testElement = document.createElement('div');
    testElement.style.display = 'none';
    document.body.appendChild(testElement);

    var cookieBanner = new CookieBanner();

    cookieBanner.showCookieMessage();

    expect(testElement.style.display).toEqual('none');

  });

  test('CookieBanner.prototype.showCookieMessage does not set display to block if cookie policy cookie is found', () => {

    // Mock getCookie so that cookie policy cookie is found
    jest.mock('../../../app/javascript/cookie-banner/cookie-functions.js');
    cookieFunctionsModule.getCookie = jest.fn().mockImplementation(
      () => { return true }
    );

    var testElement = document.createElement('div');
    testElement.style.display = 'none';
    document.body.appendChild(testElement);

    var cookieBanner = new CookieBanner(testElement);

    cookieBanner.showCookieMessage();

    expect(testElement.style.display).toEqual('none');

  });

  test('CookieBanner.prototype.hideCookieMessage sets display to none if this.$module exists, and calls preventDefault on populated event', () => {

    var mockEvent = new CustomEvent('mockEvent');

    var testElement = document.createElement('div');
    testElement.style.display = 'block';
    document.body.appendChild(testElement);

    testElement.dispatchEvent(mockEvent);

    var eventSpy = jest.spyOn(mockEvent, 'preventDefault');

    var cookieBanner = new CookieBanner(testElement);

    cookieBanner.hideCookieMessage(mockEvent);

    expect(testElement.style.display).toEqual('none');
    expect(eventSpy).toBeCalledTimes(1);

  });

  test('CookieBanner.prototype.hideCookieMessage works as expected if no this.$module or event.target found', () => {

    var mockEvent = new CustomEvent('mockEvent');

    var testElement = document.createElement('div');
    testElement.style.display = 'block';
    document.body.appendChild(testElement);

    // Overwrite mockEvent.target with null so that the condition under test is not met
    Object.defineProperty(mockEvent, 'target', {value: null, writable: true});

    testElement.dispatchEvent(mockEvent);

    var eventSpy = jest.spyOn(mockEvent, 'preventDefault');

    var cookieBanner = new CookieBanner();

    cookieBanner.hideCookieMessage(mockEvent);

    expect(testElement.style.display).toEqual('block');
    expect(eventSpy).toBeCalledTimes(0);

  });

  test('CookieBanner.prototype.setCookieConsent works as expected when analyticsConsent argument is true', () => {

    // We're not able to mock the inherited InitialiseAnalytics function,
    // so set the window.gon.global.env value to ensure we don't traverse
    // this function too deeply, as this isn't what is under test
    window.gon = { global: { env: 'production' } };

    // Mock setConsentCookie
    jest.mock('../../../app/javascript/cookie-banner/cookie-functions.js');
    cookieFunctionsModule.getCookie = jest.fn();

    var testElement = document.createElement('div');
    testElement.setAttribute('data-module', 'nlhf-cookie-banner')
    document.body.appendChild(testElement);

    var cookieBanner = new CookieBanner(testElement);

    cookieBanner.$module.showConfirmationMessage = jest.fn();
    cookieBanner.$module.cookieBannerConfirmationMessage = { focus: jest.fn() };

    var showConfirmationMessageSpy = jest.spyOn(cookieBanner.$module, 'showConfirmationMessage');
    var focusSpy = jest.spyOn(cookieBanner.$module.cookieBannerConfirmationMessage, 'focus');

    cookieBanner.setCookieConsent(true);

    expect(showConfirmationMessageSpy.mock.calls).toEqual(
      [
        [true]
      ]
    )
    expect(focusSpy).toBeCalledTimes(1);

  });

  test('CookieBanner.prototype.setCookieConsent works as expected when analyticsConsent argument is false', () => {

    // We're not able to mock the inherited InitialiseAnalytics function,
    // so set the window.gon.global.env value to ensure we don't traverse
    // this function too deeply, as this isn't what is under test
    window.gon = { global: { env: 'production' } };

    // Mock setConsentCookie
    jest.mock('../../../app/javascript/cookie-banner/cookie-functions.js');
    cookieFunctionsModule.getCookie = jest.fn();

    var testElement = document.createElement('div');
    testElement.setAttribute('data-module', 'nlhf-cookie-banner')
    document.body.appendChild(testElement);

    var cookieBanner = new CookieBanner(testElement);

    cookieBanner.$module.showConfirmationMessage = jest.fn();
    cookieBanner.$module.cookieBannerConfirmationMessage = { focus: jest.fn() };

    var showConfirmationMessageSpy = jest.spyOn(cookieBanner.$module, 'showConfirmationMessage');
    var focusSpy = jest.spyOn(cookieBanner.$module.cookieBannerConfirmationMessage, 'focus');

    cookieBanner.setCookieConsent(false);

    expect(showConfirmationMessageSpy.mock.calls).toEqual(
      [
        [false]
      ]
    )
    expect(focusSpy).toBeCalledTimes(1);

  });

  test('CookieBanner.prototype.showConfirmationMessage works as expected when analyticsConsent argument is true', () => {

    var cookieBannerWrapperElement = document.createElement('div');
    cookieBannerWrapperElement.classList.add('nlhf-cookie-banner__wrapper');
    cookieBannerWrapperElement.style.display = 'block';

    var cookieBannerConfirmationMessageElement = document.createElement('div');
    cookieBannerConfirmationMessageElement.classList.add('nlhf-cookie-banner__confirmation-message');
    cookieBannerConfirmationMessageElement.style.display = 'none';

    cookieBannerWrapperElement.appendChild(cookieBannerConfirmationMessageElement);
    document.body.appendChild(cookieBannerWrapperElement);

    var cookieBanner = new CookieBanner(cookieBannerWrapperElement);

    cookieBanner.$module.cookieBannerConfirmationMessage = cookieBannerConfirmationMessageElement;

    cookieBanner.showConfirmationMessage(true);

    expect(cookieBannerWrapperElement.style.display).toEqual('none');
    expect(cookieBannerConfirmationMessageElement.style.display).toEqual('block');
    expect(cookieBannerConfirmationMessageElement.innerHTML).toEqual('You’ve accepted analytics cookies.')

  });

  test('CookieBanner.prototype.showConfirmationMessage works as expected when analyticsConsent argument is false', () => {

    var cookieBannerWrapperElement = document.createElement('div');
    cookieBannerWrapperElement.classList.add('nlhf-cookie-banner__wrapper');
    cookieBannerWrapperElement.style.display = 'block';

    var cookieBannerConfirmationMessageElement = document.createElement('div');
    cookieBannerConfirmationMessageElement.classList.add('nlhf-cookie-banner__confirmation-message');
    cookieBannerConfirmationMessageElement.style.display = 'none';

    cookieBannerWrapperElement.appendChild(cookieBannerConfirmationMessageElement);
    document.body.appendChild(cookieBannerWrapperElement);

    var cookieBanner = new CookieBanner(cookieBannerWrapperElement);

    cookieBanner.$module.cookieBannerConfirmationMessage = cookieBannerConfirmationMessageElement;

    cookieBanner.showConfirmationMessage(false);

    expect(cookieBannerWrapperElement.style.display).toEqual('none');
    expect(cookieBannerConfirmationMessageElement.style.display).toEqual('block');
    expect(cookieBannerConfirmationMessageElement.innerHTML).toEqual('You told us not to use analytics cookies.')

  });

});