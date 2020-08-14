require('cookie-functions.js');
import {getCookie} from 'cookie-functions.js';
import {setCookie} from 'cookie-functions.js';
import {Cookie} from 'cookie-functions.js';
import {getConsentCookie} from 'cookie-functions.js';
import {setConsentCookie} from 'cookie-functions.js';
import {checkConsentCookie} from 'cookie-functions.js';
import {checkConsentCookieCategory} from 'cookie-functions.js';


describe('cookie-functions test suite', () => {
  
  /**
  * We clear the document contents - otherwise it persists between tests. 
  * We clear all mocks, otherwise they persist between tests
  */
   afterEach(() => {
     document.getElementsByTagName('html')[0].innerHTML = '';
     document.cookie.split(';').forEach(function(c) {
      document.cookie = c.trim().split('=')[0] + '=;' + 'expires=Thu, 01 Jan 1970 00:00:00 UTC;';
      });
     jest.clearAllMocks();
   });

  test('getCookie - returns null if no cookies exist in document"', () => {
    expect(getCookie('a name')).toEqual(null);
  });
  
  test('getCookie - returns null if no name passed to getCookie"', () => {
    expect(getCookie()).toEqual(null);
  });

  test('getCookie - test when cookies are passed in - but no match to name is found"', () => {
    document.cookie = ' a=1; b=1; c=1; d=1;'
    expect(getCookie('e')).toEqual(null);
  });

  test('getCookie - test when cookies are passed in - and a match is found"', () => {

    document.cookie = "a=1";
    document.cookie = "b=2";
    document.cookie = "c=3";

    expect(getCookie('b')).toEqual("2");

  });
  
  test('Cookie - returns name if the passed value is undefined"', () => {
    document.cookie = 'myTest=1';
    expect(Cookie('myTest', undefined, undefined)).toEqual('1');
  });

  test('Cookie - removes a set cookie if the passed value is false"', () => {
    document.cookie = 'myTest=1; nlhf_cookies_policy=1';
    expect(Cookie('nlhf_cookies_policy', false, undefined)).toEqual(undefined);
    expect(document.cookie).toEqual('myTest=1');
  });

  test('Cookie - removes a set cookie if the passed value is null', () => {
    document.cookie = 'myTest=1; nlhf_cookies_policy=1';
    expect(Cookie('nlhf_cookies_policy', null, undefined)).toEqual(undefined);
    expect(document.cookie).toEqual('myTest=1');
  });

  test('Cookie - adds cookie if passed options is undefined', () => {

    // Expiration date of cookie is set to 30 days be default when
    // an options argument of undefined is passed, but it is not
    // possible to retrieve the expiration date of a cookie from
    // client-side code unless this expiration date is written to
    // a cookie of it's own or to localStorage, etc.

    document.cookie = 'myTest=1';
    expect(Cookie('nlhf_cookies_policy', 1, undefined)).toEqual(undefined);
    expect(document.cookie).toEqual('myTest=1; nlhf_cookies_policy=1');

  });

  test('Cookie - adds cookie if passed options is specified in a number of days', () => {

    // Expiration date of cookie is set to 30 days be default when
    // an options argument of undefined is passed, but it is not
    // possible to retrieve the expiration date of a cookie from
    // client-side code unless this expiration date is written to
    // a cookie of it's own or to localStorage, etc.

    document.cookie = 'myTest=1';
    expect(Cookie('nlhf_cookies_policy', 1, { days: 50 })).toEqual(undefined);
    expect(document.cookie).toEqual('myTest=1; nlhf_cookies_policy=1');

  });

  test('getConsentCookie - returns null if a consent cookie is not found', () => {
    document.cookie = 'not_a_consent_cookie=1';
    expect(getConsentCookie()).toEqual(null);
  });

  test('getConsentCookie - returns null if a consent cookie not containing an object is found', () => {
    document.cookie = 'nlhf_cookies_policy=string';
    expect(getConsentCookie()).toEqual(null);
  });

  test('getConsentCookie - returns the consent cookie object if a valid consent cookie is found', () => {
    document.cookie = 'nlhf_cookies_policy={"key": "val"}';
    expect(getConsentCookie()).toEqual({"key": "val"});
  });
  
  test('getConsentCookie - returns the consent cookie object if a valid consent cookie is found and the first JSON.parse returns a non-object', () => {

    // Mock the first JSON.parse() implementation to return a string so
    // that we enter the second conditional statement, where we then return
    // a legitimate object from the second JSON.parse statement, which
    // we can assert against in the function return
    jest.spyOn(JSON, 'parse')
      .mockImplementationOnce(() => 'myCoolString')
      .mockImplementationOnce(() => JSON.parse('{"key": "val"}'))

    document.cookie = 'nlhf_cookies_policy="{"key": "val"}"';
    expect(getConsentCookie()).toEqual({"key": "val"});

  });

  test('setConsentCookie - adds the consent cookie if no consent cookie is found and if options is empty', () => {
    setConsentCookie({});
    expect(document.cookie).toEqual('nlhf_cookies_policy={\"analytics\":false}');
  });

  test('setConsentCookie - adds the same consent cookie if a consent cookie is found and if options is empty', () => {

    // Expiration date of cookie is set to 365 days by default but 
    // it is not possible to retrieve the expiration date of a cookie from
    // client-side code unless this expiration date is written to
    // a cookie of it's own or to localStorage, etc.

    document.cookie = 'nlhf_cookies_policy={"analytics": "test"}';

    setConsentCookie({});
    expect(document.cookie).toEqual('nlhf_cookies_policy={\"analytics\":\"test\"}');

  });

  test('setConsentCookie - adds the same consent cookie if a consent cookie is found and options are unchanged', () => {

    document.cookie = 'nlhf_cookies_policy={"analytics": "true"}';
    document.cookie = '_hjAbsoluteSessionInProgress=1';

    setConsentCookie({"analytics": true});
    expect(document.cookie).toEqual('nlhf_cookies_policy={\"analytics\":true}; _hjAbsoluteSessionInProgress=1');

  });

  test('setConsentCookie - if setting the consent cookie analytics to false, then any analytics cookies are removed', () => {

    document.cookie = 'nlhf_cookies_policy={"analytics": true}'; 
    document.cookie = '_hjClosedSurveyInvites=1';

    setConsentCookie({"analytics": false});
    expect(document.cookie).toEqual('nlhf_cookies_policy={\"analytics\":false}');

  });

  test('checkConsentCookieCategory - should return true if no consent cookie exists but cookieName is in known list', () => {

    // Initialise test with no consent cookie set
    document.cookie = '_hjClosedSurveyInvites=1';

    expect(checkConsentCookieCategory('_hjClosedSurveyInvites', 'analytics')).toEqual(true);
    expect(document.cookie).toEqual('_hjClosedSurveyInvites=1');


  });

  test('checkConsentCookieCategory - should return true if consent cookie exists and has analytics set to true', () => {

    document.cookie = 'nlhf_cookies_policy={"analytics": true}';
    document.cookie = '_hjClosedSurveyInvites=1';

    expect(checkConsentCookieCategory('_hjClosedSurveyInvites', 'analytics')).toEqual(true);
    expect(document.cookie).toEqual('_hjClosedSurveyInvites=1; nlhf_cookies_policy={\"analytics\": true}');

  });

  test('checkConsentCookieCategory - should return undefined if cookie is unknown', () => {
    document.cookie = 'nlhf_cookies_policy={"analytics": true}';
    expect(checkConsentCookieCategory('unknownCookie', 'unknownCategory')).toEqual(undefined);
  });

  test('checkConsentCookie - should return true if cookieName is nlhf_cookies_policy', () => {
    expect(checkConsentCookie('nlhf_cookies_policy', 'test')).toEqual(true);
  });

  test('checkConsentCookie - should return true if cookieName is test and cookieValue is null', () => {
    expect(checkConsentCookie('test', null)).toEqual(true);
  });

  test('checkConsentCookie - should return true if cookieName is test and cookieValue is false', () => {
    expect(checkConsentCookie('test', false)).toEqual(true);
  });

  test('checkConsentCookie - if cookie is known, should return consent cookie value', () => {
    document.cookie = 'nlhf_cookies_policy={"analytics": "testValue"}';
    expect(checkConsentCookie('_hjClosedSurveyInvites', 'analytics')).toEqual('testValue');
  });

  test('checkConsentCookie - if cookie is not known, should return false', () => {
    expect(checkConsentCookie('cookieName', 'cookieValue')).toEqual(false);
  });

  test('setCookie - a cookie will not be set if the cookie is unknown to the service', () => {
    setCookie('name', 'value', 'options')
    expect(document.cookie).toEqual('');
  });

  test('setCookie - a cookie will be set if the consent cookie is set to true', () => {
    document.cookie = 'nlhf_cookies_policy={"analytics": true}';
    setCookie('_hjClosedSurveyInvites', 'value', 'options')
    expect(document.cookie).toEqual('nlhf_cookies_policy={\"analytics\": true}; _hjClosedSurveyInvites=value');
  });

  test('setCookie - a cookie will not be set if the consent cookie is not set to true', () => {
    document.cookie = 'nlhf_cookies_policy={"analytics": false}';
    setCookie('_hjClosedSurveyInvites', 'value', 'options')
    expect(document.cookie).toEqual('nlhf_cookies_policy={\"analytics\": false}');
  });
  

});
