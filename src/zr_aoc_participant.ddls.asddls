@AccessControl.authorizationCheck: #CHECK

@EndUserText.label: '##GENERATED ZAOC_PARTICIPANT'

define root view entity ZR_AOC_PARTICIPANT
  as select from zaoc_participant as Participant

  composition [0..*] of ZR_AOC_DAY as _Days

{
  key participant_uuid      as ParticipantUUID,

      fullyear              as Fullyear,
      problems_solved       as ProblemsSolved,
      auth_cookie           as AuthCookie,
      gen_package           as GenPackage,
//sap_username as SapUsername,

      @Semantics.user.createdBy: true
      created_by            as CreatedBy,

      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,

      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      
      case 
          when created_by = $session.user then 'X' 
          else 'X' 
      end as RestrictedAccess,

      _Days
}
