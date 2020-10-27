`default_nettype none

module abstractFSM(
  input  logic [3:0] hMove,
  output logic [3:0] cMove,
  output logic       win,
  input  logic       clock, reset_N
);

  enum logic [2:0] { cStart, first, second, win1, win2, win3 } 
    currState, nextState;

  // Next State Generator
  always_comb begin
    case (currState)
      cStart: begin
        nextState = (hMove == 4'd6) ? first : cStart;
      end
      first: begin
        nextState = (hMove == 4'd9) ? second :
          (hMove == 4'd2 || hMove == 4'd3 || hMove == 4'd4 || hMove == 4'd7 ||
           hMove == 4'd8) ? win1 : first;
      end
      second: begin
        nextState = (hMove == 4'd2) ? win3 :
          (hMove == 4'd4 || hMove == 4'd7 || hMove == 4'd8) ? win2 : second;
      end
      win1: nextState = win1;
      win2: nextState = win2;
      win3: nextState = win3;
      default: nextState = cStart;
    endcase
  end

  // Output Generator
  always_comb begin
    win = 1'b0;
    unique case (currState)
      cStart: cMove = 4'd5;
      first: cMove = 4'd1;
      second: cMove = 4'd3;
      win1: begin
        cMove = 4'd9;
        win = 1'b1;
      end
      win2: begin
        cMove = 4'd2;
        win = 1'b1;
      end
      win3: begin
        cMove = 4'd7;
        win = 1'b1;
      end
    endcase
  end

  always_ff @(posedge clock)
    if (~reset_N)
      currState <= cStart;
    else
      currState <= nextState;
endmodule: abstractFSM

// module abstractFSM_test();
//   logic [3:0] cMove, hMove;
//   logic       win, clock, reset_N;

//   abstractFSM DUT (.*);

//   initial begin
//     $monitor($time,, "state=%s, hMove=%d, cMove=%d, win=%b",
//             DUT.currState.name, hMove, cMove, win);
//     clock = 0;
//     forever #5 clock = ~clock;
//   end

//   initial begin
//     // Initialize Values
//     hMove <= 4'b0000; reset_N <= 0;

//     @(posedge clock);

//     // Release reset
//     reset_N <= 1;
//     // Start test path for cStart
//     hMove <= 4'd0;
//     @(posedge clock);
//     hMove <= 4'd1;
//     @(posedge clock);
//     hMove <= 4'd2;
//     @(posedge clock);
//     hMove <= 4'd3;
//     @(posedge clock);
//     hMove <= 4'd4;
//     @(posedge clock);
//     hMove <= 4'd5;
//     @(posedge clock);
//     hMove <= 4'd7;
//     @(posedge clock);
//     hMove <= 4'd8;
//     @(posedge clock);
//     hMove <= 4'd9;
//     @(posedge clock);
//     hMove <= 4'd10;
//     @(posedge clock);
//     hMove <= 4'd11;
//     @(posedge clock);
//     hMove <= 4'd12;
//     @(posedge clock);
//     hMove <= 4'd13;
//     @(posedge clock);
//     hMove <= 4'd14;
//     @(posedge clock);
//     hMove <= 4'd15;
//     @(posedge clock);
    
//     hMove <= 4'd6;
//     @(posedge clock); // To first

//     // Start testing First
//     hMove <= 4'd0;
//     @(posedge clock);
//     hMove <= 4'd1;
//     @(posedge clock);
//     hMove <= 4'd5;
//     @(posedge clock);
//     hMove <= 4'd6;
//     @(posedge clock);
//     hMove <= 4'd10;
//     @(posedge clock);
//     hMove <= 4'd11;
//     @(posedge clock);
//     hMove <= 4'd12;
//     @(posedge clock);
//     hMove <= 4'd13;
//     @(posedge clock);
//     hMove <= 4'd14;
//     @(posedge clock);
//     hMove <= 4'd15;
//     @(posedge clock);

//     // To win1
//     hMove <= 4'd2;
//     @(posedge clock);
//     reset_N <= 0;
//     @(posedge clock);
//     reset_N <= 1;
    
//     hMove <= 4'd3;
//     @(posedge clock);
//     reset_N <= 0;
//     @(posedge clock);
//     reset_N <= 1;
    
//     hMove <= 4'd4;
//     @(posedge clock);
//     reset_N <= 0;
//     @(posedge clock);
//     reset_N <= 1;
    
//     hMove <= 4'd7;
//     @(posedge clock);
//     reset_N <= 0;
//     @(posedge clock);
//     reset_N <= 1;

//     hMove <= 4'd8;
//     @(posedge clock);

//     // Start testing win1
//     for (logic [3:0] i = 4'd0; i < 4'b1111; i++) begin
//       hMove <= i;
//       @(posedge clock);
//     end
//     hMove <= 4'b1111;
//     @(posedge clock);
//     reset_N <= 0;
//     @(posedge clock);
//     reset_N <= 1;

//     hMove <= 4'd6;
//     @(posedge clock);
//     reset_N <= 0;
//     @(posedge clock);
//     reset_N <= 1;

//     // Start testing second
//     hMove <= 4'd6;
//     @(posedge clock);
//     hMove <= 4'd9;
//     @(posedge clock);
//     reset_N <= 0;
//     @(posedge clock); // test reset
//     reset_N <=1;
//     hMove <= 4'd6;
//     @(posedge clock);
//     hMove <= 4'd9;
//     @(posedge clock);
//     hMove <= 4'd0;
//     @(posedge clock); // test invalid cases
//     hMove <= 4'd1;
//     @(posedge clock);
//     hMove <= 4'd3;
//     @(posedge clock);
//     hMove <= 4'd5;
//     @(posedge clock);
//     hMove <= 4'd9;
//     @(posedge clock);
//     hMove <= 4'd10;
//     @(posedge clock);
//     hMove <= 4'd11;
//     @(posedge clock);
//     hMove <= 4'd12;
//     @(posedge clock);
//     hMove <= 4'd13;
//     @(posedge clock);
//     hMove <= 4'd14;
//     @(posedge clock);
//     hMove <= 4'd15;
//     @(posedge clock);

//     hMove <= 4'd2;
//     @(posedge clock); // to win3

//     // Test win3
//     for (logic [3:0] i = 4'd0; i < 4'b1111; i++) begin
//       hMove <= i;
//       @(posedge clock);
//     end
//     hMove <= 4'b1111;
//     @(posedge clock);
//     reset_N <= 0;
//     @(posedge clock);
//     reset_N <= 1;
//     hMove <= 4'd6;
//     @(posedge clock);
//     hMove <= 4'd9;
//     @(posedge clock);
//     hMove <= 4'd4;
//     @(posedge clock);

//     reset_N <= 0;
//     @(posedge clock);
//     reset_N <= 1;
//     hMove <= 4'd6;
//     @(posedge clock);
//     hMove <= 4'd9;
//     @(posedge clock);
//     hMove <= 4'd7;
//     @(posedge clock);

//     reset_N <= 0;
//     @(posedge clock);
//     reset_N <= 1;
//     hMove <= 4'd6;
//     @(posedge clock);
//     hMove <= 4'd9;
//     @(posedge clock); // return to second
//     hMove <= 4'd8;
//     @(posedge clock);
    
//     // Test win2
//     for (logic [3:0] i = 4'd0; i < 4'b1111; i++) begin
//       hMove <= i;
//       @(posedge clock);
//     end
//     hMove <= 4'b1111;
//     @(posedge clock);
//     reset_N <= 0;
//     @(posedge clock);
//     reset_N <= 1;
//     @(posedge clock);
//     #1 $finish;
//   end
// endmodule: abstractFSM_test

module BCDtoSevenSegment(
  input logic [3:0] bcd,
  output logic [6:0] segment
);

  always_comb
      case (bcd)
          4'b0000: segment = 7'b100_0000;
          4'b0001: segment = 7'b111_1001;
          4'b0010: segment = 7'b010_0100;
          4'b0011: segment = 7'b011_0000;
          4'b0100: segment = 7'b001_1001;
          4'b0101: segment = 7'b001_0010;
          4'b0110: segment = 7'b000_0010;
          4'b0111: segment = 7'b111_1000;
          4'b1000: segment = 7'b000_0000;
          4'b1001: segment = 7'b001_1000;
          default: segment = 7'b111_1111; // Display is off by default
      endcase
endmodule: BCDtoSevenSegment