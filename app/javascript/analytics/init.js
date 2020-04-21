import * as PageAnalytics from './analytics'

window.NLHFGOVUKFrontend = window.NLHFGOVUKFrontend || {}

function InitialiseAnalytics () {
    // guard against being called more than once, only call on production
    if (!('analytics' in window.NLHFGOVUKFrontend) &&  window.gon.global.env === 'production')  {

        // Load Analytics libraries
        PageAnalytics.LoadHotjar()


    }
}

export default InitialiseAnalytics