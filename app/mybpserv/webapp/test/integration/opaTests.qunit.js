sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'mybpserv/app/mybpserv/test/integration/FirstJourney',
		'mybpserv/app/mybpserv/test/integration/pages/BusinessPartnerSetList',
		'mybpserv/app/mybpserv/test/integration/pages/BusinessPartnerSetObjectPage',
		'mybpserv/app/mybpserv/test/integration/pages/AddressSetObjectPage'
    ],
    function(JourneyRunner, opaJourney, BusinessPartnerSetList, BusinessPartnerSetObjectPage, AddressSetObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('mybpserv/app/mybpserv') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheBusinessPartnerSetList: BusinessPartnerSetList,
					onTheBusinessPartnerSetObjectPage: BusinessPartnerSetObjectPage,
					onTheAddressSetObjectPage: AddressSetObjectPage
                }
            },
            opaJourney.run
        );
    }
);