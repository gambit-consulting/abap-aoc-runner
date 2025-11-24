@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'VH for Packages'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define view entity ZI_AOC_PACKAGE_VH
  as select from tdevc

{
      @UI.lineItem: [ { position: 10 } ]
  key devclass   as TargetPackage,

      @UI.lineItem: [ { position: 20 } ]
      created_by as CreatedBy
}

where devclass like '$%'
and created_by <> 'SAP'
