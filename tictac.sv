module dFlipFlop
    (output logic q,
     input logic d, clock, reset);

    always @(posedge clock)
    if (reset == 1)
        q <= 0;
    else
        q <= d;
endmodule: dFlipFlop

module myStructuralFSM
    (input logic [3:0] hMove,
     output logic [3:0] cMove,
     output logic win,
     input logic clock, reset);

logic q0, q1, q2;
logic d0, d1, d2;

dFlipFlop ff2(.d(d2), .q(q2), .clock, .reset),
          ff1(.d(d1), .q(q1), .clock, .reset),
          ff0(.d(d0), .q(q0), .clock, .reset);

logic tmp, tmp1, tmp2, tmp3;
assign tmp= (~q2 & ~q1 & ~q0) &
            ((hMove[3]                                  ) |
            (~hMove[3] & ~hMove[2]                      ) |
            (~hMove[3] & hMove[2] & ~hMove[1]           ) |
            (~hMove[3] & hMove[2] & hMove[1] & hMove[0] ));

assign tmp1= (~q2 & ~q1 & q0) &
            ((~hMove[3] & ~hMove[2] & ~hMove[1]          ) |
            (~hMove[3] & hMove[2] & ~hMove[1] & hMove[0]) |
            (~hMove[3] & hMove[2] & hMove[1] & ~hMove[0]) |
            (hMove[3] & ~hMove[2] & hMove[1]            ) |
            (hMove[3] & hMove[2]                        ));

assign tmp2= (~q2 & ~q1 & q0) &
           ((~hMove[3] & ~hMove[2] & hMove[1]            ) |
           (~hMove[3] & hMove[2] & ~hMove[1] & ~hMove[0] ) |
           (~hMove[3] & hMove[2] & hMove[1] & hMove[0] ) |
           (hMove[3] & ~hMove[2] & ~hMove[1] & ~hMove[0]));

assign tmp3=(~q2 & q1 & ~q0) &
            ((~hMove[3] & ~hMove[2] & ~hMove[1]           ) |
            (~hMove[3] & ~hMove[2] & hMove[1] & hMove[0] ) |
            (~hMove[3] & hMove[2] & ~hMove[1] & hMove[0] ) |
            (~hMove[3] & hMove[2] & hMove[1] & ~hMove[0] ) |
            (hMove[3] & ~hMove[2] & ~hMove[1] & hMove[0] ) |
            (hMove[3] & ~hMove[2] & hMove[1]             ) |
            (hMove[3] & hMove[2]                         ));

/* Next State Logic */
assign d2= (~hMove[3] & ~hMove[2] & hMove[1] & ~hMove[0] & ~q2 & q1 & ~q0) |
           (~hMove[3] & hMove[2] & ~hMove[1] & ~hMove[0] & ~q2 & q1 & ~q0) |
           (~hMove[3] & hMove[2] & hMove[1] & hMove[0]   & ~q2 & q1 & ~q0) |
           (hMove[3] & ~hMove[2] & ~hMove[1] & ~hMove[0] & ~q2 & q1 & ~q0) |
           (q2 & ~q1 & ~q0) |
           (q2 & ~q1 & q0);

assign d1= (hMove[3] & ~hMove[2] & ~hMove[1] & hMove[0]  & ~q2 & ~q1 & q0) |
           tmp2 |
           tmp3 |
           (~q2 & q1 & q0);

assign d0= (~hMove[3] & hMove[2] & hMove[1] & ~hMove[0]  & ~q2 & ~q1 & ~q0) |
           tmp1 |
           tmp2 |
           (~hMove[3] & ~hMove[2] & hMove[1] & ~hMove[0] & ~q2 & q1 & ~q0) |
           (~q2 & q1 & q0) |
           (q2 & ~q1 & q0);


/* Output Logic */
assign cMove[3]= ~q2 & q1 & q0;

assign cMove[2]= (~hMove[3] & hMove[2] & hMove[1] & ~hMove[0]  & ~q2 & ~q1 & ~q0) |
                 tmp |
                 (q2 & ~q1 & q0);

assign cMove[1]= tmp3 |
                 (~hMove[3] & ~hMove[2] & hMove[1] & ~hMove[0] & ~q2 & q1 & ~q0) |
                 (~hMove[3] & hMove[2] & ~hMove[1] & ~hMove[0] & ~q2 & q1 & ~q0) |
                 (~hMove[3] & hMove[2] & hMove[1] & hMove[0]   & ~q2 & q1 & ~q0) |
                 (hMove[3] & ~hMove[2] & ~hMove[1] & ~hMove[0] & ~q2 & q1 & ~q0) |
                 (q2 & ~q1 & ~q0) |
                 (q2 & ~q1 & q0);

assign cMove[0]= ~(q2 & ~q1 & ~q0);

assign win= (~q2 & q1 & q0) |
            (q2 & ~q1 & ~q0) |
            (q2 & ~q1 & q0);

endmodule : myStructuralFSM

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