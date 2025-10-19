// Custom Vietnamese translations for Jitsi Meet
// This file overrides default translations to provide custom messages

(function() {
    'use strict';

    // Wait for Jitsi APP to be ready
    function injectCustomTranslations() {
        if (typeof window.APP !== 'undefined' && window.APP.translation) {
            try {
                // Get existing Vietnamese translations
                const customTranslations = {
                    // Kicked out messages
                    'dialog.kickTitle': 'Bạn được mời ra khỏi cuộc họp',
                    'dialog.kickMessage': 'Bạn được mời ra khỏi cuộc họp, cảm ơn bạn đã tham gia',
                    'dialog.sessTerminated': 'Bạn được mời ra khỏi cuộc họp, cảm ơn bạn đã tham gia',
                    'dialog.kicked': 'Bạn được mời ra khỏi cuộc họp, cảm ơn bạn đã tham gia',
                    'dialog.sessionTerminated': 'Bạn được mời ra khỏi cuộc họp, cảm ơn bạn đã tham gia',
                    'kickedOut': 'Bạn được mời ra khỏi cuộc họp, cảm ơn bạn đã tham gia',

                    // Additional kicked messages
                    'dialog.kickedTitle': 'Bạn được mời ra khỏi cuộc họp',
                    'dialog.youWereKicked': 'Bạn được mời ra khỏi cuộc họp, cảm ơn bạn đã tham gia',
                    'dialog.thankYou': 'Cảm ơn bạn đã tham gia',

                    // Application name
                    'app.name': 'Họp trực tuyến',
                    'app.title': 'Họp trực tuyến',

                    // Welcome page
                    'welcomepage.appDescription': 'Họp trực tuyến của Báo Tuổi Trẻ',
                    'welcomepage.title': 'Họp trực tuyến',

                    // Participant names
                    'defaultLocalDisplayName': 'Tôi',
                    'defaultRemoteDisplayName': 'Khách'
                };

                // Try to add or update translations
                if (typeof window.APP.translation.addLanguage === 'function') {
                    window.APP.translation.addLanguage('vi', customTranslations);
                    console.log('✓ Custom Vietnamese translations loaded successfully');
                } else if (typeof window.APP.translation.translateString === 'function') {
                    // Alternative method: monkey-patch the translation function
                    const originalTranslate = window.APP.translation.translateString.bind(window.APP.translation);
                    window.APP.translation.translateString = function(key, options) {
                        if (customTranslations[key]) {
                            return customTranslations[key];
                        }
                        return originalTranslate(key, options);
                    };
                    console.log('✓ Custom Vietnamese translations patched successfully');
                }

                return true;
            } catch (error) {
                console.error('Failed to inject custom translations:', error);
                return false;
            }
        } else {
            // Retry if APP is not ready yet
            setTimeout(injectCustomTranslations, 200);
        }
    }

    // Start injection when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', injectCustomTranslations);
    } else {
        injectCustomTranslations();
    }

    // Also try on window load
    window.addEventListener('load', injectCustomTranslations);

})();
