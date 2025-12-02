CLASS zcl_aoc_proxy_days DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    INTERFACES if_rap_query_provider.
    PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_aoc_proxy_days IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

  ENDMETHOD.

  METHOD if_rap_query_provider~select.
    DATA result_set TYPE TABLE OF zi_aoc_day_vh.

    FINAL(top) = io_request->get_paging( )->get_page_size( ).
    FINAL(skip) = io_request->get_paging( )->get_offset( ).
    " TODO: variable is assigned but never used (ABAP cleaner)
    FINAL(requested_fields) = io_request->get_requested_elements( ).
    " TODO: variable is assigned but never used (ABAP cleaner)
    FINAL(sort_order) = io_request->get_sort_elements( ).
    FINAL(filters) = io_request->get_filter( )->get_as_ranges( ).

    DATA(puzzle_year) = 2015.

    FINAL(current_year) = sy-datum+0(4).
    FINAL(current_month) = sy-datum+4(2).
    FINAL(current_day) = sy-datum+6(2).

    WHILE puzzle_year <= current_year.

      FINAL(number_of_days) = COND #( WHEN puzzle_year < 2025
                                      THEN 25
                                      ELSE COND #( WHEN puzzle_year < current_year
                                                   THEN 12
                                                   ELSE COND #( WHEN current_month < 12 THEN 0 ELSE current_day ) ) ).
      DO number_of_days TIMES.
        APPEND VALUE #( CalendarYear = puzzle_year
                        CalendarDay  = sy-index  ) TO result_set.
      ENDDO.

      puzzle_year += 1.

    ENDWHILE.

    SORT result_set BY CalendarYear DESCENDING
                       CalendarDay DESCENDING.

    IF filters IS NOT INITIAL.
      LOOP AT filters INTO FINAL(filter).
        CASE filter-name.
          WHEN 'CALENDARYEAR'.
            DELETE result_set WHERE calendaryear NOT IN filter-range.
          WHEN 'CALENDARDAY'.
            DELETE result_set WHERE calendarday NOT IN filter-range.
        ENDCASE.
      ENDLOOP.

    ENDIF.

    IF io_request->is_total_numb_of_rec_requested( ).
      io_response->set_total_number_of_records( lines( result_set ) ).
    ENDIF.

    " extract data from result_set according to paging via skip and top
    IF skip IS NOT INITIAL.
      DELETE result_set FROM 1 TO skip.
    ENDIF.

    IF top IS NOT INITIAL AND lines( result_set ) > top.
      DELETE result_set FROM top + 1.
    ENDIF.

    IF io_request->is_data_requested( ).
      io_response->set_data( result_set ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
