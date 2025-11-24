CLASS zcl_aoc_generator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_bgmc_op_single.

  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS create_class.
ENDCLASS.



CLASS zcl_aoc_generator IMPLEMENTATION.
  METHOD if_bgmc_op_single~execute.
    create_class( ).
  ENDMETHOD.

  METHOD create_class.
    FINAL(put_operation) = xco_generation=>environment->local->for-clas->create_put_operation( ).

    FINAL(specification) = put_operation->add_object( 'ZCL_MS_DEMO_XCO_GENERATED'
      )->set_package( '$ZMS_AOC'
      )->create_form_specification( ).

    specification->set_short_description( |Generated| ).
    specification->definition->set_superclass( 'ZCL_AOC_SOLVER_BASE' ).

    FINAL(method1) = specification->definition->section-private->add_method( 'solve_part1' ).
    method1->set_redefinition( ).
    FINAL(method2) = specification->definition->section-private->add_method( 'solve_part2' ).
    method2->set_redefinition( ).

    FINAL(source) = |result = 0.|.
    specification->implementation->add_method( 'solve_part1' )->set_source( VALUE #( ( source ) ) ).
    specification->implementation->add_method( 'solve_part2' )->set_source( VALUE #( ( source ) ) ).

    TRY.
        " TODO: variable is assigned but never used (ABAP cleaner)
        FINAL(result) = put_operation->execute( ).
      CATCH cx_xco_gen_put_exception INTO FINAL(lo_exception).
        WRITE lo_exception->get_longtext( ).
        WRITE lo_exception->get_text( ).
        " TODO: variable is assigned but never used (ABAP cleaner)
        FINAL(section) = lo_exception->findings->for->clas.

    ENDTRY.
  ENDMETHOD.

ENDCLASS.
