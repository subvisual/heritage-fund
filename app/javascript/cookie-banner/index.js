import CookieBanner from '../cookie-banner/cookie-banner'
import InitialiseAnalytics from '../analytics/init'
import CookieSettings from './cookie-settings'
import { getConsentCookie } from '../cookie-banner/cookie-functions'
const $cookieBanner = document.querySelector('[data-module="nlhf-cookie-banner"]')
if ($cookieBanner) {
    new CookieBanner($cookieBanner).init()
}

const $cookieSettingsPage = document.querySelector('[data-module="nlhf-cookie-settings"]')
if ($cookieSettingsPage) {
    new CookieSettings($cookieSettingsPage).init()
}

const currentConsentCookie = getConsentCookie()
if (currentConsentCookie && currentConsentCookie.analytics) {
    InitialiseAnalytics()
}