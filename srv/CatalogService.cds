using {myBPServ.db.master, myBPServ.db.transaction } from '../db/datamodel';

service CatalogService @(path: 'CatalogService') {

    function setBPID() returns BusinessPartnerSet;
    function setOrderNo() returns OrdersSet;
    function setOrderItemID() returns OrderItemsSet;

    @Capabilities: {
        Insertable: true,
        Readable  : true,
        Updatable : true,
        Deletable : true
    }
    entity BusinessPartnerSet @(
        odata.draft.enabled,
        Common.DefaultValuesFunction: 'setBPID') 
        as projection on master.BusinessPartnerSet;

    entity AddressSet                                as projection on master.AddressSet
        actions {
            action setDefaultAddress();
            action removeDefaultAddress();
        };
    entity ProductSet as projection on master.ProductSet;

    entity OrdersSet @( 
        Common.DefaultValuesFunction : 'setOrderNo' 
    ) as projection on transaction.OrdersSet
    actions {
        function setOrder() returns OrdersSet
    };
    entity OrderItemsSet @( 
        Common.DefaultValuesFunction: 'setOrderItemID'
    ) as projection on transaction.OrderItemsSet
    actions { 
        action calItemTax();
        // function setItemID() returns OrderItemsSet;
    };


}
