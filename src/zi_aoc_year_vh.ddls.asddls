@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'VH for available years'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define view entity ZI_AOC_YEAR_VH
  as select from I_CalendarYear

{
  key CalendarYear
}

where CalendarYear >= '2015' and CalendarYear <= substring($session.system_date, 1, 4)
