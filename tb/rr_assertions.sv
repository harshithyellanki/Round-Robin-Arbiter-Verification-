module rr_assertions (rr_if rif);

  // Derive N from interface signal widths (works even if interface is parameterized)
  localparam int N = $bits(rif.req);

  // ------------------------------------------------------------
  // 1) gnt must always be onehot0 (0 or exactly 1 bit set)
  // ------------------------------------------------------------
  property p_onehot0;
    @(posedge rif.clk) disable iff (!rif.rst_n)
      $onehot0(rif.gnt);
  endproperty

  a_onehot0: assert property (p_onehot0)
    else $error("[%0t][SVA] gnt not onehot0: gnt=0x%0h", $time, rif.gnt);


  // ------------------------------------------------------------
  // 2) Correct check for a registered arbiter:
  //    If gnt[i] is 1 in THIS cycle, then req[i] must have been 1 in the PREVIOUS cycle
  //    because gnt is registered from gnt_d computed using previous-cycle req.
  // ------------------------------------------------------------
  genvar i;
  generate
    for (i = 0; i < N; i++) begin : G

      property p_gnt_implies_req_prev;
        @(posedge rif.clk) disable iff (!rif.rst_n)
         rif.gnt[i] |-> $past(rif.req[i]);
        //rif.req[i] |=> rif.gnt[i];
      endproperty

      a_gnt_implies_req_prev: assert property (p_gnt_implies_req_prev)
        else $error("[%0t][SVA] gnt[%0d]=1 but past req[%0d]=0 (past_req=0x%0h, gnt=0x%0h)",
                    $time, i, i, $past(rif.req), rif.gnt);

    end
  endgenerate


  // ------------------------------------------------------------
  // 3) If enable==0 in this cycle, then gnt must be 0 next cycle
  //    (registered output)
  // ------------------------------------------------------------
  property p_disable_means_no_grant_next;
    @(posedge rif.clk) disable iff (!rif.rst_n)
      (!rif.enable) |=> (rif.gnt == '0);
  endproperty

  a_disable_means_no_grant_next: assert property (p_disable_means_no_grant_next)
    else $error("[%0t][SVA] enable=0 but next cycle gnt!=0 : gnt=0x%0h", $time, rif.gnt);


  // ------------------------------------------------------------
  // 4) If enable==1 and at least one request is high in this cycle,
  //    then next cycle someone must be granted (registered output).
  // ------------------------------------------------------------
  property p_req_means_grant_next;
    @(posedge rif.clk) disable iff (!rif.rst_n)
      (rif.enable && (|rif.req)) |=> (|rif.gnt);
  endproperty

  a_req_means_grant_next: assert property (p_req_means_grant_next)
    else $error("[%0t][SVA] enable=1 and req!=0 but next cycle gnt==0 (req=0x%0h)",
                $time, rif.req);

endmodule
