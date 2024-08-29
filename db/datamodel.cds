namespace myBPServ.db;

using { managed, cuid, Currency } from '@sap/cds/common';
using { myBPServ.commons } from './commons';

context master {
    entity BusinessPartnerSet : cuid, managed {
        BPID: String(10) @(title: '{i18n>BPID}');
        CompanyName: String  @(title: '{i18n>CompanyName}');
        ContactPerson: String  @(title: '{i18n>ContactPerson}');
        BankName: String  @(title: '{i18n>BankName}');
        Total_Sell_Amount: commons.AmountT @(title: '{i18n>Total_Sell_Amount}');
        address: Composition of many AddressSet on
                 address.BusinessPartner = $self;
        orders: Composition of many transaction.OrdersSet on
                 orders.BusinessPartner = $self;         
    }

    entity AddressSet : cuid, commons.address, commons.communication {
        Name: String  @(title: '{i18n>Name}');
        DefaultAddr: String(1) @(title: '{i18n>DefaultAddr}');
        BusinessPartner: Association to BusinessPartnerSet;
    }

    entity ProductSet : cuid, managed {
      ProductID: String(40)  @(title: '{i18n>ProductID}'); 
      Description: String @(title: '{i18n>Description}');
      Supplier_Guid: Association to BusinessPartnerSet;
      Currency: Currency;
      Price: Decimal(15, 2) @(title: '{i18n>Product Price}');      
    }


}

context transaction {
    entity OrdersSet : cuid, managed, commons.amount {
        OrderID: String(40) @(title: '{i18n>OrderID}');
        BusinessPartner: Association to master.BusinessPartnerSet;
        overall_status: String(1) @(title: '{i18n>overall_status}');
        Items: Composition of many OrderItemsSet on Items.Parent_Key = $self;
    }

    entity OrderItemsSet : cuid, commons.amount {
        Parent_Key: Association to transaction.OrdersSet;
        OrderItemPos: Integer @(title: '{i18n>OrderItemPos}');
        Product_ID: String(40) @(title: '{i18n>Product_ID}');
        Product_Desc: String @(title: '{i18n>Product_Desc}');
    }
}



