CLASS lhc_day DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.
    CONSTANTS co_transport TYPE sxco_transport VALUE ''.

    METHODS createSolverClass FOR DETERMINE ON SAVE
      IMPORTING keys FOR Day~createSolverClass.

    METHODS downloadPuzzleInput FOR DETERMINE ON SAVE
      IMPORTING keys FOR Day~downloadPuzzleInput.

    METHODS create_class
      IMPORTING !package   TYPE devclass
                class_name TYPE seoclsname
      RAISING   cx_xco_gen_put_exception.

    METHODS download_input
      IMPORTING iv_year        TYPE numc4
                iv_day         TYPE int1
                iv_auth_cookie TYPE zde_aoc_cookie
      RETURNING VALUE(result)  TYPE string
      RAISING   cx_web_http_client_error.

    METHODS save_input_as_text
      IMPORTING !input     TYPE string
                class_name TYPE seoclsname
      RAISING   cx_static_check.

ENDCLASS.

CLASS lhc_day IMPLEMENTATION.
  METHOD createsolverclass.
    READ ENTITIES OF zr_aoc_participant IN LOCAL MODE
         ENTITY day
         FIELDS ( DayUUID ParticipantUUID DayNumber SolverClassName )
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_days)
         ENTITY day BY \_participant
         FIELDS ( Fullyear GenPackage CreatedBy )
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_participants).

    LOOP AT lt_days INTO FINAL(ls_day).

      IF ls_day-SolverClassName IS NOT INITIAL.
        CONTINUE.
      ENDIF.

      READ TABLE lt_participants INTO FINAL(ls_participant)
           WITH KEY ParticipantUUID = ls_day-ParticipantUUID.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      " Klassenname generieren: ZCL_AOC_USERNAME_YEAR_DAY
      DATA(lv_class_name) = |ZCL_AOC_{ ls_participant-createdby }_{ ls_participant-Fullyear }_{ ls_day-DayNumber }|.
      TRANSLATE lv_class_name TO UPPER CASE.

      TRY.
          " Klasse mit XCO Framework anlegen
          create_class( class_name = CONV #( lv_class_name )
                        package    = ls_participant-GenPackage ).

          " Klassennamen in Entity zurückschreiben
          MODIFY ENTITIES OF zr_aoc_participant IN LOCAL MODE
                 ENTITY day
                 UPDATE FIELDS ( SolverClassName )
                 WITH VALUE #( ( %tky            = ls_day-%tky
                                 SolverClassName = lv_class_name ) )
                 " TODO: variable is assigned but never used (ABAP cleaner)
                 REPORTED FINAL(ls_reported).

        CATCH cx_xco_gen_put_exception INTO FINAL(lx_gen).
          " Fehlerbehandlung
          APPEND VALUE #( %tky = ls_day-%tky
                          %msg = new_message_with_text(
                                     severity = if_abap_behv_message=>severity-error
                                     text     = |Fehler beim Anlegen der Klasse: { lx_gen->get_text( ) }| ) )
                 TO reported-day.
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.

  METHOD downloadpuzzleinput.
    " Lese die benötigten Daten
    READ ENTITIES OF zr_aoc_participant IN LOCAL MODE
      ENTITY day
        FIELDS ( DayUUID ParticipantUUID DayNumber SolverClassName TextID )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_days)
      ENTITY day BY \_participant
        FIELDS ( Fullyear AuthCookie )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_participants).

    LOOP AT lt_days INTO DATA(ls_day).
      " Nur wenn noch kein Input geladen wurde
      IF ls_day-TextID IS INITIAL.
        READ TABLE lt_participants INTO DATA(ls_participant)
          WITH KEY ParticipantUUID = ls_day-ParticipantUUID.
        IF sy-subrc = 0 AND ls_participant-AuthCookie IS NOT INITIAL.
          TRY.
              " Input von AOC Website laden
              DATA(lv_input) = download_input(
                iv_year        = ls_participant-fullyear
                iv_day         = ls_day-DayNumber
                iv_auth_cookie = ls_participant-AuthCookie ).

              " Input als TEXT speichern
              save_input_as_text(
                input      = lv_input
                class_name = CONV #( ls_day-SolverClassName ) ).

              " Text-ID in Entity zurückschreiben
              MODIFY ENTITIES OF zr_aoc_participant IN LOCAL MODE
                ENTITY day
                  UPDATE FIELDS ( TextID )
                  WITH VALUE #( ( %tky = ls_day-%tky
                                  TextID = ls_day-SolverClassName ) )
                REPORTED DATA(ls_reported).

            CATCH cx_web_http_client_error INTO DATA(lx_http).
              APPEND VALUE #( %tky = ls_day-%tky
                              %msg = new_message_with_text(
                                severity = if_abap_behv_message=>severity-error
                                text     = |Fehler beim Download: { lx_http->get_text( ) }| )
                            ) TO reported-day.
            CATCH cx_static_check INTO DATA(lx_text).
              APPEND VALUE #( %tky = ls_day-%tky
                              %msg = new_message_with_text(
                                severity = if_abap_behv_message=>severity-error
                                text     = |Fehler beim Speichern: { lx_text->get_text( ) }| )
                            ) TO reported-day.
          ENDTRY.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD create_class.
    CALL FUNCTION 'ZAOC_GENERATE_CLASS' DESTINATION 'SELF'
      EXPORTING im_class_name = class_name
                im_package    = package.
  ENDMETHOD.

  METHOD download_input.
    " HTTP Destination für adventofcode.com

    FINAL(url) = |https://adventofcode.com/{ iv_year }/day/{ iv_day }/input|.
    cl_http_client=>create_by_url( EXPORTING url    = url
                                   IMPORTING client = FINAL(client) ).

    client->request->set_method( if_http_request=>co_request_method_get ).

    " Session Cookie setzen
    client->request->set_cookie( name  = 'session'
                                 value = CONV #( iv_auth_cookie ) ).

    " Request ausführen
    client->send( ).
    client->receive( ).

    " Response verarbeiten
    client->response->get_status( IMPORTING code   = FINAL(status_code)
                                  " TODO: variable is assigned but never used (ABAP cleaner)
                                            reason = FINAL(status_reason) ).

    IF status_code = 200.
      FINAL(response) = client->response->get_data( ).
      FINAL(response_conv) = /ui2/cl_abap2json=>conv_xstring_to_string( response ).

      result = response_conv.

    ENDIF.
  ENDMETHOD.

  METHOD save_input_as_text.
    DATA text_lines TYPE tline_t.

    FINAL(input_tab) = VALUE string_table( ( input ) ).

    CALL FUNCTION 'CONVERT_STREAM_TO_ITF_TEXT'
      EXPORTING stream_lines = input_tab
                lf           = abap_true
      TABLES    itf_text     = text_lines.

    " Text speichern mit SAVE_TEXT
    CALL FUNCTION 'SAVE_TEXT'
      EXPORTING  client   = sy-mandt
                 header   = VALUE thead( tdobject = 'TEXT'
                                         tdname   = conv tdobname( class_name )
                                         tdid     = 'ST'
                                         tdspras  = sy-langu )
      TABLES     lines    = text_lines
      EXCEPTIONS OTHERS   = 1.

    " Commit für Textbaustein
    CALL FUNCTION 'COMMIT_TEXT'.
  ENDMETHOD.



ENDCLASS.

CLASS LHC_PARTICIPANT DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR Participant
        RESULT result.
ENDCLASS.

CLASS LHC_PARTICIPANT IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.
ENDCLASS.
