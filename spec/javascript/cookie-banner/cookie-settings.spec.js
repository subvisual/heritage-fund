import {CookieSettings} from 'cookie-settings.js';
import * as cookieFunctionsModule from '../../../app/javascript/cookie-banner/cookie-functions.js';

describe('cookie-settings test suite', () => {
  
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

    test('CookieSettings.prototype.init initialises by calling the correct methods', () => {

      var testElement = document.createElement('div');
      document.body.appendChild(testElement);

      var cookieSettings = new CookieSettings(testElement);

      var submitSettingsFormBindSpy = jest.spyOn(cookieSettings.submitSettingsForm, 'bind');
      var eventListenerSpy = jest.spyOn(cookieSettings.$module, 'addEventListener');
      var hideCookierBannerSpy = jest.spyOn(cookieSettings, 'hideCookieBanner');
      var setInitialFormValuesSpy = jest.spyOn(cookieSettings, 'setInitialFormValues');

      cookieSettings.init();

      expect(submitSettingsFormBindSpy).toBeCalledTimes(1);
      expect(eventListenerSpy.mock.calls).toEqual(
        [
          ['submit', expect.any(Function)]
        ]
      );
      expect(hideCookierBannerSpy).toBeCalledTimes(1);
      expect(setInitialFormValuesSpy).toBeCalledTimes(1);

    });

    test('CookieSettings.prototype.setInitialFormValues returns if no consent cookie is found', () => {

      // Mock getConsentCookie so that no consent cookie is found
      jest.mock('../../../app/javascript/cookie-banner/cookie-functions.js');
      cookieFunctionsModule.getConsentCookie = jest.fn().mockImplementation(
        () => { return null }
      );

      var testElement = document.createElement('div');
      document.body.appendChild(testElement);

      var cookieSettings = new CookieSettings(testElement);

      expect(cookieSettings.setInitialFormValues()).toEqual(undefined);

    });

    test('CookieSettings.prototype.setInitialFormValues sets on radioButton.checked to true', () => {

      // Mock getConsentCookie so that a consent cookie is found
      jest.mock('../../../app/javascript/cookie-banner/cookie-functions.js');
      cookieFunctionsModule.getConsentCookie = jest.fn().mockImplementation(
        () => { return { analytics: true } }
      );

      var testElement = document.createElement('div');

      var inputElement = document.createElement('input');
      inputElement.setAttribute('type', 'checkbox');
      inputElement.setAttribute('name', 'cookies-analytics');
      inputElement.setAttribute('value', 'On');
      
      testElement.appendChild(inputElement);

      document.body.appendChild(testElement);

      var cookieSettings = new CookieSettings(testElement);

      var hideWarningMessageSpy = jest.spyOn(cookieSettings, 'hideWarningMessage');

      expect(cookieSettings.setInitialFormValues()).toEqual(undefined);
      expect(hideWarningMessageSpy).toBeCalledTimes(1);
      expect(inputElement.checked).toEqual(true);

    });

    test('CookieSettings.prototype.setInitialFormValues sets off radioButton.checked to true', () => {

      // Mock getConsentCookie so that a consent cookie is found
      jest.mock('../../../app/javascript/cookie-banner/cookie-functions.js');
      cookieFunctionsModule.getConsentCookie = jest.fn().mockImplementation(
        () => { return { analytics: false } }
      );

      var testElement = document.createElement('div');

      var inputElement = document.createElement('input');
      inputElement.setAttribute('type', 'checkbox');
      inputElement.setAttribute('name', 'cookies-analytics');
      inputElement.setAttribute('value', 'Off');
      
      testElement.appendChild(inputElement);

      document.body.appendChild(testElement);

      var cookieSettings = new CookieSettings(testElement);

      var hideWarningMessageSpy = jest.spyOn(cookieSettings, 'hideWarningMessage');

      expect(cookieSettings.setInitialFormValues()).toEqual(undefined);
      expect(hideWarningMessageSpy).toBeCalledTimes(1);
      expect(inputElement.checked).toEqual(true);

    });

    test('CookieSettings.prototype.submitSettingsForm displays error message and returns false if options.analytics is undefined', () => {

      var mockEvent = new CustomEvent('mockEvent');

      var testElement = document.createElement('div');

      var inputElement = document.createElement('input');
      inputElement.setAttribute('type', 'checkbox');
      inputElement.setAttribute('name', 'cookies-analytics');
      inputElement.setAttribute('value', 'Off'); // Value being set ot 'Off' means that options.analytics will be undefined
      
      testElement.appendChild(inputElement);

      document.body.appendChild(testElement);

      // Dispatch the event, which causes event.target to populate
      testElement.dispatchEvent(mockEvent);

      var cookieSettings = new CookieSettings(testElement);

      var showErrorMessageSpy = jest.spyOn(cookieSettings, 'showErrorMessage');

      expect(cookieSettings.submitSettingsForm(mockEvent)).toEqual(false);
      expect(showErrorMessageSpy).toBeCalledTimes(1);

    });

    test('CookieSettings.prototype.submitSettingsForm works as expected when analytics cookie exists', () => {

      // We're not able to mock the inherited InitialiseAnalytics function,
      // so set the window.gon.global.env value to ensure we don't traverse
      // this function too deeply, as this isn't what is under test
      window.gon = { global: { env: 'production' } };

      // Mock setConsentCookie
      jest.mock('../../../app/javascript/cookie-banner/cookie-functions.js');
      cookieFunctionsModule.setConsentCookie = jest.fn();

      var mockEvent = new CustomEvent('mockEvent');

      var testElement = document.createElement('div');

      var inputElement = document.createElement('input');
      inputElement.setAttribute('type', 'checkbox');
      inputElement.setAttribute('name', 'cookies-analytics');
      inputElement.setAttribute('value', 'On');
      inputElement.setAttribute('checked', 'checked');
      
      testElement.appendChild(inputElement);

      document.body.appendChild(testElement);

      // Dispatch the event, which causes event.target to populate
      testElement.dispatchEvent(mockEvent);

      var cookieSettings = new CookieSettings(testElement);

      var showErrorMessageSpy = jest.spyOn(cookieSettings, 'showErrorMessage');
      var hideWarningMessageSpy = jest.spyOn(cookieSettings, 'hideWarningMessage');
      var hideErrorMessageSpy = jest.spyOn(cookieSettings, 'hideErrorMessage');
      var showConfirmationMessageSpy = jest.spyOn(cookieSettings, 'showConfirmationMessage').mockImplementation(
        () => { return 'test' }
      );
      var setConsentCookieSpy = jest.spyOn(cookieFunctionsModule, 'setConsentCookie');

      expect(cookieSettings.submitSettingsForm(mockEvent)).toEqual(false);
      expect(showErrorMessageSpy).toBeCalledTimes(0);
      expect(setConsentCookieSpy).toBeCalledTimes(1);
      expect(hideWarningMessageSpy).toBeCalledTimes(1);
      expect(hideErrorMessageSpy).toBeCalledTimes(1);
      expect(showConfirmationMessageSpy).toBeCalledTimes(1);

    });

    test('showConfirmationMessage works as expected when getReferrerLink returns something different to document.location.pathname', () => {

      var testElement = document.createElement('div');

      // Add element with #nlhf-cookie-settings-confirmation, should have display of none
      var confirmationMessageElement = document.createElement('div');
      confirmationMessageElement.setAttribute('id', 'nlhf-cookie-settings-confirmation');
      confirmationMessageElement.style.display = 'none';
      testElement.appendChild(confirmationMessageElement);

      // Add element with .nlhf-cookie-settings__prev-page - should have no href and display of none
      var previousPageLinkElement = document.createElement('a');
      previousPageLinkElement.classList.add('nlhf-cookie-settings__prev-page');
      previousPageLinkElement.style.display = 'none';
      testElement.appendChild(previousPageLinkElement);

      document.body.appendChild(testElement);

      var cookieSettings = new CookieSettings(testElement);

      // Store getReferrerLink reference, so that we can un-mock it later
      var beforeMock = CookieSettings.prototype.getReferrerLink;

      CookieSettings.prototype.getReferrerLink = jest.fn().mockImplementation(() => { return 'test' });

      document.body.scrollTop = 50;

      cookieSettings.showConfirmationMessage();

      expect(previousPageLinkElement.href).toEqual('http://localhost/test');
      expect(previousPageLinkElement.style.display).toEqual('block');
      expect(confirmationMessageElement.style.display).toEqual('block');
      expect(document.body.scrollTop).toEqual(0);

      // Put getReferrerLink back to un-mocked state
      CookieSettings.prototype.getReferrerLink = beforeMock;

    });

    test('showConfirmationMessage works as expected when getReferrerLink returns the same as document.location.pathname', () => {

      var testElement = document.createElement('div');

      // Add element with #nlhf-cookie-settings-confirmation, should have display of none
      var confirmationMessageElement = document.createElement('div');
      confirmationMessageElement.setAttribute('id', 'nlhf-cookie-settings-confirmation');
      confirmationMessageElement.style.display = 'none';
      testElement.appendChild(confirmationMessageElement);

      // Add element with .nlhf-cookie-settings__prev-page - should have no href and display of none
      var previousPageLinkElement = document.createElement('a');
      previousPageLinkElement.classList.add('nlhf-cookie-settings__prev-page');
      previousPageLinkElement.style.display = 'none';
      testElement.appendChild(previousPageLinkElement);

      document.body.appendChild(testElement);

      var cookieSettings = new CookieSettings(testElement);

      // Store getReferrerLink reference, so that we can un-mock it later
      var beforeMock = CookieSettings.prototype.getReferrerLink;

      CookieSettings.prototype.getReferrerLink = jest.fn().mockImplementation(() => { return '/' });

      document.body.scrollTop = 50;

      cookieSettings.showConfirmationMessage();

      expect(previousPageLinkElement.href).toEqual('');
      expect(previousPageLinkElement.style.display).toEqual('none');
      expect(confirmationMessageElement.style.display).toEqual('block');
      expect(document.body.scrollTop).toEqual(0);

      // Put getReferrerLink back to un-mocked state
      CookieSettings.prototype.getReferrerLink = beforeMock;

    });

    test('getReferrerLink works as expected if referrer is set', () => {

      var testElement = document.createElement('div');
      document.body.appendChild(testElement);

      Object.defineProperty(
        document,
        'referrer',
        {
          value: 'http://localhost/referrerTest',
          configurable: true 
        }
      );

      var cookieSettings = new CookieSettings(testElement);

      expect(cookieSettings.getReferrerLink()).toEqual('/referrerTest');

    });

    test('getReferrerLink works as expected if referrer is not set', () => {

      var testElement = document.createElement('div');
      document.body.appendChild(testElement);

      Object.defineProperty(
        global.document,
        'referrer',
        {
          value: undefined,
          configurable: true 
        }
      );

      var cookieSettings = new CookieSettings(testElement);

      expect(cookieSettings.getReferrerLink()).toEqual(false);

    });

    test('showErrorMessage should work as expected', () => {

      var testElement = document.createElement('div');
      testElement.classList.add('nlhf-cookie-settings__error');
      testElement.style.display = 'none';
      document.body.appendChild(testElement);

      var formGroupElement = document.createElement('div');
      formGroupElement.setAttribute('id', 'nlhf-cookie-settings-form-group');
      document.body.appendChild(formGroupElement);

      var cookieSettings = new CookieSettings(testElement);

      cookieSettings.showErrorMessage();

      expect(testElement.style.display).toEqual('block');
      expect(formGroupElement.classList.contains('govuk-form-group--error')).toEqual(true);

    });

    test('hideErrorMessage should set errorMessage.style.display to none', () => {

      var testElement = document.createElement('div');
      testElement.setAttribute('id', 'nlhf-cookie-settings-error');
      testElement.style.display = 'block';
      document.body.appendChild(testElement);

      var cookieSettings = new CookieSettings(testElement);

      cookieSettings.hideErrorMessage();

      expect(testElement.style.display).toEqual('none');

    });

    test('hideWarningMessage should set warningMessage.style.display to none', () => {

      var testElement = document.createElement('div');
      testElement.setAttribute('id', 'nlhf-cookie-settings-warning');
      testElement.style.display = 'block';
      document.body.appendChild(testElement);

      var cookieSettings = new CookieSettings(testElement);

      cookieSettings.hideWarningMessage();

      expect(testElement.style.display).toEqual('none');

    });

    test('hideCookieBanner should set cookieBanner.style.display to none', () => {

      var testElement = document.createElement('div');
      testElement.classList.add('nlhf-cookie-banner');
      testElement.style.display = 'block';
      document.body.appendChild(testElement);

      var cookieSettings = new CookieSettings(testElement);

      cookieSettings.hideCookieBanner();

      expect(testElement.style.display).toEqual('none');

    });

});