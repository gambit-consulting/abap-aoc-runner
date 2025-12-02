@AccessControl.authorizationCheck: #CHECK

@EndUserText.label: 'Projection View for ZR_AOC_DAY'

@Metadata.allowExtensions: true

define view entity ZC_AOC_DAY
  as projection on ZR_AOC_DAY

{
  key DayUUID,

      ParticipantUUID,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_AOC_DAY_VH', element: 'CalendarDay' },
                                            additionalBinding: [ { element: 'CalendarYear',
                                                                   localElement: 'CalendarYear' } ] } ]
      DayNumber,

      _Participant.Fullyear as CalendarYear,
      Part1Solved,
      Part2Solved,
      SolverClassName,
      TextID,
      LocalLastChangedAt,

      _Participant: redirected to parent ZC_AOC_PARTICIPANT
}
