sap.ui.define(['sap/fe/test/ListReport'], function(ListReport) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ListReport(
        {
            appId: 'mybpserv.app.mybpserv',
            componentId: 'BusinessPartnerSetList',
            contextPath: '/BusinessPartnerSet'
        },
        CustomPageDefinitions
    );
});