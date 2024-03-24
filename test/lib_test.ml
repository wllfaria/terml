let () =
  Alcotest.run "Crossterml tests"
    [
      ("Color", Color_test.tests);
      ("Style", Style_test.tests);
      ("Command", Command_test.tests);
      ("Event", Event_test.tests);
    ]
