using CatalogService as service from '../../srv/CatalogService';

annotate service.BusinessPartnerSet with @(UI: {
    SelectionFields      : [
        BPID,
        CompanyName,
        address.city,
        address.country_code
    ],

    //---BEGIN SORTING --- //
    PresentationVariant  : {
        Visualizations: ['@UI.LineItem', ],
        $Type         : 'UI.PresentationVariantType',
        SortOrder     : [{
            $Type   : 'Common.SortOrderType',
            Property: CompanyName,
        }, ],
    },
    //----END SORTING --- //

    LineItem             : [
        {
            $Type                  : 'UI.DataField',
            Value                  : BPID,
            ![@Common.FieldControl]: #ReadOnly,
        },
        {
            $Type: 'UI.DataField',
            Value: CompanyName,
        },
        {
            $Type: 'UI.DataField',
            Value: ContactPerson,
        },
        {
            $Type: 'UI.DataField',
            Value: address.city,
        },
        {
            $Type: 'UI.DataField',
            Value: address.street,
        },
        {
            $Type: 'UI.DataField',
            Value: address.country_code,
        },
    ],

    HeaderInfo           : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : 'BP',
        TypeNamePlural: 'BPs',
        Title         : {
            Label: 'ID',
            Value: ID,
        },
        Description   : {
            Label: 'Company Name',
            Value: CompanyName,
        },
        ImageUrl      : 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/SAP_2011_logo.svg/2560px-SAP_2011_logo.svg.png',
    },

    Facets               : [
        {
            $Type : 'UI.CollectionFacet',
            Label : 'Details',
            Facets: [{
                $Type : 'UI.ReferenceFacet',
                Label : 'Business Partner Details',
                Target: '@UI.FieldGroup#BPDetails',
            }, ],
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: address.![@UI.LineItem],
            Label : 'BP Address',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: ![orders/@UI.SelectionPresentationVariant#OrderLineItem],
            Label : 'Orders by Business Partner',
        },
    ],

    FieldGroup #BPDetails: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type                  : 'UI.DataField',
                Value                  : BPID,
                ![@Common.FieldControl]: #ReadOnly,
            },
            {
                $Type: 'UI.DataField',
                Value: CompanyName,
            },
            {
                $Type: 'UI.DataField',
                Value: ContactPerson,
            },
            {
                $Type: 'UI.DataField',
                Value: BankName,
            },
            {
                $Type                  : 'UI.DataField',
                Value                  : Total_Sell_Amount,
                ![@Common.FieldControl]: #ReadOnly,
            },
        ],
    },
});

annotate service.AddressSet with @(UI: {
    LineItem                  : [
        // --Begin Add action Fields --//
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'CatalogService.setDefaultAddress',
            Label : '{i18n>setDefaultAddress}',
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'CatalogService.removeDefaultAddress',
            Label : '{i18n>removeDefaultAddress}',
        },
        //---End Add Action Fields --//
        {
            $Type                  : 'UI.DataField',
            Value                  : DefaultAddr,
            ![@Common.FieldControl]: #ReadOnly,
        },
        {
            $Type: 'UI.DataField',
            Value: Name,
        },
        {
            $Type: 'UI.DataField',
            Value: city,
        },
        {
            $Type: 'UI.DataField',
            Value: country_code,
        },
        {
            $Type: 'UI.DataField',
            Value: street,
        },
    ],

    HeaderInfo                : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : 'Address',
        TypeNamePlural: 'Addresses',
        Title         : {
            Label                  : 'Address ID',
            Value                  : ID,
            ![@Common.FieldControl]: #ReadOnly,
        },
        Description   : {
            Label                  : 'Business Partner',
            Value                  : BusinessPartner_ID,
            ![@Common.FieldControl]: #ReadOnly,
        }
    },
    Facets                    : [{
        $Type : 'UI.ReferenceFacet',
        Target: '@UI.FieldGroup#AddressDetails',
        Label : 'Address Maintenance',
    }, ],
    FieldGroup #AddressDetails: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: Name,
            },
            {
                $Type: 'UI.DataField',
                Value: city,
            },
            {
                $Type: 'UI.DataField',
                Value: country_code,
            },
            {
                $Type: 'UI.DataField',
                Value: houseNumber,
            },
            {
                $Type: 'UI.DataField',
                Value: street,
            },
            {
                $Type: 'UI.DataField',
                Value: state,
            },
        ],
    },
});

annotate CatalogService.BusinessPartnerSet with {
    BPID @Common.ValueList: {
        $Type          : 'Common.ValueListType',
        Parameters     : [{
            $Type            : 'Common.ValueListParameterInOut',
            ValueListProperty: 'BPID',
            LocalDataProperty: BPID,
        }, ],
        CollectionPath : 'BusinessPartnerSet',
        SearchSupported: true,
        Label          : 'REPLACE_WITH_VALUE_LIST_LABEL',
    }
};

annotate CatalogService.BusinessPartnerSet with {
    CompanyName @Common.ValueList: {
        $Type          : 'Common.ValueListType',
        Parameters     : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                ValueListProperty: 'CompanyName',
                LocalDataProperty: CompanyName,
            },
            {
                $Type            : 'Common.ValueListParameterInOut',
                ValueListProperty: 'BPID',
                LocalDataProperty: BPID,
            },
        ],
        CollectionPath : 'BusinessPartnerSet',
        SearchSupported: true,
        Label          : 'REPLACE_WITH_VALUE_LIST_LABEL',
    }
};

annotate CatalogService.AddressSet with {
    city @Common.ValueList: {
        $Type          : 'Common.ValueListType',
        Parameters     : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                ValueListProperty: 'city',
                LocalDataProperty: city,
            },
            {
                $Type            : 'Common.ValueListParameterInOut',
                ValueListProperty: 'country_code',
                LocalDataProperty: country_code,
            },
        ],
        CollectionPath : 'AddressSet',
        SearchSupported: true,
        Label          : 'REPLACE_WITH_VALUE_LIST_LABEL',
    }
};

annotate service.AddressSet with actions {
    setDefaultAddress @(
        Core.OperationAvailable            : {$edmJson: {$Ne: [
            {$Path: 'in/DefaultAddr'},
            'X'
        ]}},
        Common.SideEffects.TargetProperties: ['in/DefaultAddr'],
    );
};

annotate service.AddressSet with actions {
    removeDefaultAddress @(
        Core.OperationAvailable            : {$edmJson: {$Ne: [
            {$Path: 'in/DefaultAddr'},
            ''
        ]}},
        Common.SideEffects.TargetProperties: ['in/DefaultAddr'],
    );
};

annotate service.OrdersSet with @(UI: {

    PresentationVariant  : {
        Visualizations : [
            '@UI.LineItem#OrderLineItem',
        ],
        $Type         : 'UI.PresentationVariantType',
        SortOrder     : [{
            $Type   : 'Common.SortOrderType',
            Property: OrderID,
        }, ],
    },

    LineItem    #OrderLineItem  : [
        {
            $Type: 'UI.DataField',
            Value: OrderID,
        },
        {
            $Type: 'UI.DataField',
            Value: overall_status,
        },
        {
            $Type                  : 'UI.DataField',
            Value                  : gross_amount,
            ![@Common.FieldControl]: #ReadOnly,
        },
        {
            $Type                  : 'UI.DataField',
            Value                  : tax_amount,
            ![@Common.FieldControl]: #ReadOnly,
        },
    ],
    Facets                   : [
        {
            $Type : 'UI.CollectionFacet',
            Facets: [
                {
                    $Type : 'UI.ReferenceFacet',
                    Target: '@UI.FieldGroup#OrdersDetails',
                    Label : 'Order Header',
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Target: '@UI.FieldGroup#OrdersAmount',
                    Label : 'Orders Total Amount',
                },
            ],
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: ![Items/@UI.SelectionPresentationVariant#ItemLineItem],
        },
    ],
    FieldGroup #OrdersDetails: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: OrderID,
            },
            {
                $Type: 'UI.DataField',
                Value: overall_status,
            },
        ],
    },
    FieldGroup #OrdersAmount : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type                  : 'UI.DataField',
                Value                  : gross_amount,
                ![@Common.FieldControl]: #ReadOnly,
            },
            //    {
            //        $Type : 'UI.DataField',
            //        Value : net_amount,
            //    },
            {
                $Type                  : 'UI.DataField',
                Value                  : tax_amount,
                ![@Common.FieldControl]: #ReadOnly,
            },
            {
                $Type: 'UI.DataField',
                Value: currency_code,
            },
        ],
    },
},
    UI.SelectionPresentationVariant #OrderLineItem : {
        $Type : 'UI.SelectionPresentationVariantType',
        PresentationVariant : {
            $Type : 'UI.PresentationVariantType',
            Visualizations : [
                '@UI.LineItem#OrderLineItem',
            ],
            SortOrder : [
                {
                    $Type : 'Common.SortOrderType',
                    Property : OrderID,
                    Descending : false,
                },
            ],
        },
        SelectionVariant : {
            $Type : 'UI.SelectionVariantType',
            SelectOptions : [
            ],
        },
    },);

annotate service.OrderItemsSet with @(UI: {
    PresentationVariant  : {
        Visualizations : [
            ![@UI.LineItem#ItemLineItem]
        ],
        $Type         : 'UI.PresentationVariantType',
        SortOrder     : [{
            $Type   : 'Common.SortOrderType',
            Property: OrderItemPos,
        }, ],
    },
    LineItem   #ItemLineItem        : [
        {
            $Type                  : 'UI.DataField',
            Value                  : OrderItemPos,
            ![@Common.FieldControl]: #ReadOnly,
        },
        {
            $Type: 'UI.DataField',
            Value: Product_ID,
        },
        {
            $Type                  : 'UI.DataField',
            Value                  : Product_Desc,
            ![@Common.FieldControl]: #ReadOnly,
        },
        {
            $Type: 'UI.DataField',
            Value: currency_code,
        },
        // {
        //     $Type : 'UI.DataField',
        //     Value : gross_amount,
        // },
        {
            $Type                  : 'UI.DataField',
            Value                  : net_amount,
            ![@Common.FieldControl]: #ReadOnly,
        },
        {
            $Type                  : 'UI.DataField',
            Value                  : tax_amount,
            ![@Common.FieldControl]: #ReadOnly,
        },
    ],
    HeaderInfo         : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : 'Order Item',
        TypeNamePlural: 'Items',
        Title         : {
            Label: 'Item No',
            Value: OrderItemPos,
        }
    },
    Facets             : [{
        $Type : 'UI.ReferenceFacet',
        Target: '@UI.FieldGroup#Items',
    }, ],
    FieldGroup #Items  : {
        $Type: 'UI.FieldGroupType',
        Data : [
            // {
            //     $Type : 'UI.DataField',
            //     Value : OrderItemPos,
            // },
            {
                $Type: 'UI.DataField',
                Value: Product_ID,
            },
            {
                $Type                  : 'UI.DataField',
                Value                  : Product_Desc,
                ![@Common.FieldControl]: #ReadOnly,
            },
            {
                $Type                  : 'UI.DataField',
                Value                  : currency_code,
                ![@Common.FieldControl]: #ReadOnly,
            },
            {
                $Type                  : 'UI.DataField',
                Value                  : net_amount,
                ![@Common.FieldControl]: #ReadOnly,
            },
            {
                $Type                  : 'UI.DataField',
                Value                  : tax_amount,
                ![@Common.FieldControl]: #ReadOnly,
            },
            {
                $Type : 'UI.DataFieldForAction',
                Action: 'CatalogService.calItemTax',
                Label : '{i18n>calItemTax}'
            }
        ],
    },
},
    UI.SelectionPresentationVariant #ItemLineItem : {
        $Type : 'UI.SelectionPresentationVariantType',
        PresentationVariant : {
            $Type : 'UI.PresentationVariantType',
            Visualizations : [
                '@UI.LineItem#ItemLineItem',
            ],
            SortOrder : [
                {
                    $Type : 'Common.SortOrderType',
                    Property : OrderItemPos,
                    Descending : false,
                },
            ],
        },
        SelectionVariant : {
            $Type : 'UI.SelectionVariantType',
            SelectOptions : [
            ],
        },
    },);

annotate service.OrderItemsSet with actions {
    calItemTax @(
                 // Core.OperationAvailable : {
                 //      $edmJson: { $Ne: [{ $Path: 'in/net_amount'},  ]}
                 //  },
                 // Core.OperationAvailable: {
                 //     $edmJson: {$Path: '/Singleton/enabled'}
                 // },
               Common.SideEffects.TargetProperties: ['in/tax_amount'], );
};

//  --------------------
// ---Value Help for Order Items --to Choose Products
annotate CatalogService.OrderItemsSet with {
    Product_ID @Common.ValueList: {
        $Type          : 'Common.ValueListType',
        Parameters     : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                ValueListProperty: 'ProductID',
                LocalDataProperty: Product_ID,
            },
            {
                $Type            : 'Common.ValueListParameterInOut',
                ValueListProperty: 'Description',
                LocalDataProperty: Product_Desc,
            },
            {
                $Type            : 'Common.ValueListParameterInOut',
                ValueListProperty: 'Price',
                LocalDataProperty: net_amount,
            },
            {
                $Type            : 'Common.ValueListParameterInOut',
                ValueListProperty: 'Currency_code',
                LocalDataProperty: currency_code,
            },
        ],
        CollectionPath : 'ProductSet',
        SearchSupported: true,
        Label          : 'REPLACE_WITH_VALUE_LIST_LABEL',
    }
};
// ---------------------------
