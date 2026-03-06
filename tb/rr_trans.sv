class rr_trans #(int N=4);

  rand bit         enable;
  rand bit [N-1:0] req;
  rand int unsigned ones_target;

  constraint c_enable_bias {
    enable dist {1 := 80, 0 := 20};
  }

  constraint c_ones_target {
    ones_target inside {[0:N]};
    ones_target dist {0 := 10, 1 := 45, 2 := 30, 3 := 10, [4:N] := 5};
  }

  constraint c_req_popcount {
    $countones(req) == ones_target;
  }

  function string sprint();
    return $sformatf("enable=%0d req=0x%0h ones=%0d",
                     enable, req, $countones(req));
  endfunction

endclass
