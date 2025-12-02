CLASS zcl_aoc_solver_base DEFINITION abstract
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    METHODS solve_part1 ABSTRACT
      IMPORTING !input        TYPE string_table
      RETURNING VALUE(result) TYPE zde_aoc_result.

    METHODS solve_part2 ABSTRACT
      IMPORTING !input        TYPE string_table
      RETURNING VALUE(result) TYPE zde_aoc_result.

  PROTECTED SECTION.

        METHODS get_input
      RETURNING VALUE(input) TYPE string_table.

    methods write IMPORTING
      !text TYPE string.

  PRIVATE SECTION.
    DATA writer TYPE REF TO if_oo_adt_classrun_out.
ENDCLASS.



CLASS zcl_aoc_solver_base IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    writer = out.

    FINAL(input) = get_input( ).

    FINAL(part1_result) = solve_part1( input = input ).
    FINAL(part2_result) = solve_part2( input = input ).

    write( |Part 1: { part1_result ALPHA = OUT }| ).
    write( |Part 2: { part2_result ALPHA = OUT }| ).
  ENDMETHOD.

  METHOD get_input.
    FINAL(full_class_name) = cl_abap_classdescr=>get_class_name( me ).

    SPLIT full_class_name AT '=' INTO FINAL(prefix) FINAL(class_name).

    DATA(text_lines) = VALUE tline_t( ).

    CALL FUNCTION 'READ_TEXT'
      EXPORTING  id       = 'ST'
                 language = sy-langu
                 name     = conv tdobname( class_name )
                 object   = 'TEXT'
      TABLES     lines    = text_lines
      EXCEPTIONS OTHERS   = 1.

    CALL FUNCTION 'CONVERT_ITF_TO_STREAM_TEXT'
      EXPORTING lf           = abap_true
      IMPORTING stream_lines = input
      TABLES    itf_text     = text_lines.
  ENDMETHOD.

  METHOD write.
    writer->write( text ).
  ENDMETHOD.

ENDCLASS.
