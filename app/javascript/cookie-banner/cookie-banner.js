//Adapted from https://github.com/alphagov/digitalmarketplace-govuk-frontend/blob/master/src/digitalmarketplace/components/cookie-banner/cookie-banner.js
import { getCookie, setConsentCookie } from './cookie-functions'
import InitialiseAnalytics from '../analytics/init'

const CookieBanner = function ($module) {
    this.$module = $module
}


CookieBanner.prototype.init = function ($module) {
    this.$module.hideCookieMessage = this.hideCookieMessage.bind(this)
    this.$module.showConfirmationMessage = this.showConfirmationMessage.bind(this)
    this.$module.setCookieConsent = this.setCookieConsent.bind(this)

    this.$module.cookieBanner = document.querySelector('.nlhf-cookie-banner')
    this.$module.cookieBannerConfirmationMessage = this.$module.querySelector('.nlhf-cookie-banner__confirmation')

    this.setupCookieMessage()
}

CookieBanner.prototype.setupCookieMessage = function () {
    this.$hideLink = this.$module.querySelector('button[data-hide-cookie-banner]')
    if (this.$hideLink) {
        this.$hideLink.addEventListener('click', this.$module.hideCookieMessage)
    }

    this.$acceptCookiesLink = this.$module.querySelector('button[data-accept-cookies=true]')
    if (this.$acceptCookiesLink) {
        this.$acceptCookiesLink.addEventListener('click', () => this.$module.setCookieConsent(true))
    }

    this.$rejectCookiesLink = this.$module.querySelector('button[data-accept-cookies=false]')
    if (this.$rejectCookiesLink) {
        this.$rejectCookiesLink.addEventListener('click', () => this.$module.setCookieConsent(false))
    }

    this.showCookieMessage()
}

CookieBanner.prototype.showCookieMessage = function () {

    // Show the cookie banner if policy cookie not set
    var hasCookiesPolicy = getCookie('nlhf_cookies_policy')

    if (this.$module && !hasCookiesPolicy) {
        this.$module.style.display = 'block'
    }
}

CookieBanner.prototype.hideCookieMessage = function (event) {
    if (this.$module) {
        this.$module.style.display = 'none'
    }

    if (event.target) {
        event.preventDefault()
    }
}

CookieBanner.prototype.setCookieConsent = function (analyticsConsent) {
    setConsentCookie({ analytics: analyticsConsent })

    this.$module.showConfirmationMessage(analyticsConsent)
    this.$module.cookieBannerConfirmationMessage.focus()

    if (analyticsConsent) { InitialiseAnalytics() }
}

CookieBanner.prototype.showConfirmationMessage = function (analyticsConsent) {
    var messagePrefix = analyticsConsent ? 'You’ve accepted analytics cookies.' : 'You told us not to use analytics cookies.'

    this.$cookieBannerMainContent = document.querySelector('.nlhf-cookie-banner__wrapper')
    this.$cookieBannerConfirmationMessage = document.querySelector('.nlhf-cookie-banner__confirmation-message')

    this.$cookieBannerConfirmationMessage.insertAdjacentText('afterbegin', messagePrefix)
    this.$cookieBannerMainContent.style.display = 'none'
    this.$module.cookieBannerConfirmationMessage.style.display = 'block'
}

export default CookieBanner