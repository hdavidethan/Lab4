`default_nettype none

module ChipInterface(
  input  logic [7:0]  KEY,
  input  logic [17:0] SW,
  output logic [6:0]  HEX9,
  output logic [7:0] LEDG
);

logic [3:0] hMove, cMove;
logic win, clock, reset;
logic [6:0] segment;

assign clock = ~KEY[0];
assign reset = SW[17];
assign hMove = SW[9:6];
assign HEX9 = segment;
assign LEDG[7:0] = {8{win}};

BCDtoSevenSegment BSS (.bcd(cMove), .segment);
myStructuralFSM fsm (.*);

endmodule: ChipInterface