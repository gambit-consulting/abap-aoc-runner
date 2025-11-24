FUNCTION zaoc_generate_class.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_CLASS_NAME) TYPE  SEOCLSNAME
*"     VALUE(IM_PACKAGE) TYPE  DEVCLASS
*"----------------------------------------------------------------------
  FINAL(put_operation) = xco_generation=>environment->local->for-clas->create_put_operation( ).

  FINAL(specification) = put_operation->add_object( im_class_name
    )->set_package( im_package
    )->create_form_specification( ).

  specification->set_short_description( |AoC solver class| ).
  specification->definition->set_superclass( 'ZCL_AOC_SOLVER_BASE' ).

  specification->definition->section-public->add_method( 'solve_part1' )->set_redefinition( ).
  specification->definition->section-public->add_method( 'solve_part2' )->set_redefinition( ).

  specification->implementation->add_method( 'solve_part1' )->set_source( VALUE #( ( |result = 0.| ) ) ).
  specification->implementation->add_method( 'solve_part2' )->set_source( VALUE #( ( |result = 0.| ) ) ).

  FINAL(test_class) = specification->add_test_class( |{ im_class_name }_T| ).
  test_class->definition->set_for_testing( ).
  test_class->definition->set_duration( xco_abap_unit=>duration->short ).
  test_class->definition->set_risk_level( xco_abap_unit=>risk_level->harmless ).

  test_class->definition->section-private->add_data( 'solver' )->set_type(
                                                                  xco_abap=>class( im_class_name ) ).

  test_class->definition->section-private->add_method( 'setup' ).
  test_class->definition->section-private->add_method( 'teardown' ).
  test_class->definition->section-private->add_method( 'test_solve_part1' )->set_for_testing( ).
  test_class->definition->section-private->add_method( 'test_solve_part2' )->set_for_testing( ).

  test_class->implementation->add_method( 'setup' )->set_source(
                                                      VALUE #( (  |me->solver = new { im_class_name }( ). | ) ) ).

  test_class->implementation->add_method( 'teardown' )->set_source( VALUE #( (  |free me->solver. | ) ) ).

  FINAL(test_source) = VALUE rswsourcet( ( |final(test_input) = value string_table( ( `123` ) ( `456` ) ).| )
                                         ( |final(result) = me->solver->solve_part1( test_input ).| )
                                         ( |cl_abap_unit_assert=>assert_equals( act = result exp = 0 ).| ) ).

  test_class->implementation->add_method( 'test_solve_part1' )->set_source( test_source ).
  test_class->implementation->add_method( 'test_solve_part2' )->set_source( test_source ).

  TRY.
      " TODO: variable is assigned but never used (ABAP cleaner)
      FINAL(result) = put_operation->execute( ).
    CATCH cx_xco_gen_put_exception INTO FINAL(lo_exception).
      WRITE lo_exception->get_longtext( ).
      WRITE lo_exception->get_text( ).
      " TODO: variable is assigned but never used (ABAP cleaner)
      FINAL(section) = lo_exception->findings->for->clas.

  ENDTRY.
ENDFUNCTION.
