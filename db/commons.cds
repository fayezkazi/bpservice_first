namespace myBPServ.commons;
using { Currency, Country } from '@sap/cds/common';



aspect address: {
    houseNumber: String @(title : '{i18n>houseNumber}');
    street: String @(title : '{i18n>street}');
    city: String @(title : '{i18n>city}');
    district: String @(title : '{i18n>district}');
    state: String @(title : '{i18n>state}');
    country: Country;
    pin: String @(title : '{i18n>pin}');
}

type AmountT : Decimal(10,2)@(
  Semantics.amount.Currency: 'CURRENCY_CODE',
  sap.unit: 'CURRENCY_CODE'
);

aspect amount: {
    currency: Currency;
    gross_amount: AmountT @(title : '{i18n>gross_amount}');
    net_amount: AmountT @(title : '{i18n>net_amount}');
    tax_amount: AmountT @(title : '{i18n>tax_amount}');
}

aspect communication: {
    phone_number: String @(title : '{i18n>phone_number}');
    email_id: String @(title : '{i18n>email_id}');
    webaddress: String @(title : '{i18n>webaddress}');
}


