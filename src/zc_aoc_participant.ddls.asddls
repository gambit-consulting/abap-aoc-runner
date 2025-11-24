@AccessControl.authorizationCheck: #CHECK

@EndUserText.label: 'Projection View for ZR_AOC_PARTICIPANT'

@Metadata.allowExtensions: true

define root view entity ZC_AOC_PARTICIPANT
  provider contract transactional_query
  as projection on ZR_AOC_PARTICIPANT

{
  key ParticipantUUID,

      Fullyear,
      ProblemsSolved,
      AuthCookie,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_AOC_PACKAGE_VH', element: 'TargetPackage' } } ]
      GenPackage,

      CreatedBy,
      LocalLastChangedAt,
      RestrictedAccess,

      _Days: redirected to composition child ZC_AOC_DAY
}

where CreatedBy = $session.user
