@EndUserText.label: 'VH for available days'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_AOC_PROXY_DAYS'

@UI.presentationVariant: [ { visualizations: [ { type: #AS_LINEITEM } ],
                             groupBy: [ 'CalendarYear' ],
                             sortOrder: [ { by: 'CalendarYear', direction: #DESC },
                                          { by: 'CalendarDay',  direction: #DESC } ] } ]
define custom entity ZI_AOC_DAY_VH

{
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_AOC_YEAR_VH', element: 'CalendarYear' } } ]
      @UI.lineItem: [ { position: 10 } ]
  key CalendarYear : calendaryear;

      @UI.lineItem: [ { position: 20 } ]
  key CalendarDay : calendarday;
}
