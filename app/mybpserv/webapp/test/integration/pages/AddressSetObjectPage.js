sap.ui.define(['sap/fe/test/ObjectPage'], function(ObjectPage) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ObjectPage(
        {
            appId: 'mybpserv.app.mybpserv',
            componentId: 'AddressSetObjectPage',
            contextPath: '/BusinessPartnerSet/address'
        },
        CustomPageDefinitions
    );
});