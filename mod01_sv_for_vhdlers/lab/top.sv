module top;
   logic [7:0] data_in;
   bit         clk, inc, ld, rst;
   wire [7:0] q;
   logic [7:0] q_beh;

  // define initial values and genereate reset
  initial begin : gen_rst    // "one-time" process
    clk = 0;
    rst = 0;
    ld  = 0;
    inc = 0;
    data_in = 8'h00;
    
    // reset
    @(posedge clk); // wait for rising edge    
    rst = 0;
    
    // release reset
    @(posedge clk); // wait for rising edge
    @(posedge clk); // wait for falling edge
    rst = 1;
    
    // test counter
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    inc = 1;
    #100ns;
    
    // test manual data override
    inc = 0;
    #50ns;
    data_in = 8'hAA;
    ld = 1;
    #50ns;
    
    // test conflict
    inc = 1;    
    #50ns;
    
    // test return to automatic counter
    ld = 0;
    #50ns;
    
    // use random values for coverage
    inc = 0;
    data_in = 8'h00;
    @(posedge clk);
    @(posedge clk);
    repeat(50) begin : do_multiple_sims
      {ld, inc} = $random;
      data_in   = $random;
      @(posedge clk);
      @(posedge clk);    
    end;
    $stop;    
  end;
  
  // desired behavior
  always @(posedge clk) begin: cntr_behav;
    if (!rst)
      q_beh <= 0;
    else
      if (ld)
        q_beh <= data_in;
      else if (inc)
        q_beh++;
  end
  
  // automatic validation
  always @(negedge clk) begin: test_dut;
    assert(q == q_beh) 
      $display ("OK:  q matches q_beh"); // pass statement
      else
      $error ("q differs from q_beh");   // fail statement
  end
  
  // drive clock
  always begin: gen_clk;
    #10ns;       // #100ns <----> wait for 100 ns
    clk = ~clk;
  end
   
   // shorthand component instantiation
   clear_counter DUT(.data_in(data_in),.q(q),.clk(clk),.inc(inc),.ld(ld),.rst(rst));

   
endmodule // top

   