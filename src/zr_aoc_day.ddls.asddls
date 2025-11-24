@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED ZAOC_DAY'
define view entity ZR_AOC_DAY
  as select from zaoc_day as Day
  
  association to parent ZR_AOC_PARTICIPANT as _Participant
    on $projection.ParticipantUUID = _Participant.ParticipantUUID
{
  key day_uuid as DayUUID,
  participant_uuid as ParticipantUUID,
  day_number as DayNumber,
  part1_solved as Part1Solved,
  part2_solved as Part2Solved,
  solver_class_name as SolverClassName,
  text_id as TextID,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.lastChangedBy: true
  last_changed_by as LastChangedBy,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  
  _Participant
  
}
