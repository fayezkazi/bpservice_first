// using CatalogService as service from '../../srv/CatalogService';

// annotate service.AddressSet with actions {
//  setDefaultAddress @(
//    Core.OperationAvailable : {
//      $edmJson: { $Ne: [{ $Path: 'in/DefaultAddr'}, 'X']}
//    },
//    Common.SideEffects.TargetProperties : ['in/DefaultAddr'], ) };
