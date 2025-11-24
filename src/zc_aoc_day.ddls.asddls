@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZR_AOC_DAY'
define view entity ZC_AOC_DAY
  as projection on ZR_AOC_DAY
{
  key DayUUID,
  ParticipantUUID,
  DayNumber,
  Part1Solved,
  Part2Solved,
  SolverClassName,
  TextID,
  LocalLastChangedAt,
  
  _Participant: redirected to parent ZC_AOC_PARTICIPANT
  
}
