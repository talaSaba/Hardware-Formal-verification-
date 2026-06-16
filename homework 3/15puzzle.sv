module puzzle (clk, rst, cells, direction);

input           clk, rst;
input reg[1:0]  direction;
output reg[3:0] cells[3:0][3:0];
reg[1:0]        empty_x; // x-position of the empty cell
reg[1:0]        empty_y; // y-position of the empty cell

always @ (posedge clk) begin
  if (~rst) begin
    // Initial state of the board
cells[0][0] <= 0;   
    // Position (x, y) of the empty cell
    empty_x <= 0;
    empty_y <= 0;
  end else begin
    if (direction == 2'b00 && empty_y > 3'd0) begin // left
        cells[empty_x][empty_y] <= cells[empty_x][empty_y-1];
        cells[empty_x][empty_y-1] <= 0;
        empty_y <= empty_y-1;
    end
    if (direction == 2'b01 && empty_y < 3'd3) begin // right
        cells[empty_x][empty_y] <= cells[empty_x][empty_y+1];
        cells[empty_x][empty_y+1] <= 0;
        empty_y <= empty_y+1;
    end
    if (direction == 2'b10 && empty_x > 3'd0) begin // up
        cells[empty_x][empty_y] <= cells[empty_x-1][empty_y];
        cells[empty_x-1][empty_y] <= 0;
        empty_x <= empty_x-1;
    end
    if (direction == 2'b11 && empty_x < 3'd3) begin // down
        cells[empty_x][empty_y] <= cells[empty_x+1][empty_y];
        cells[empty_x+1][empty_y] <= 0;
        empty_x <= empty_x+1;
    end
  end
end

// The solution to the 15-puzzle:
wire solution = cells[0][0] == 1 &
                cells[0][1] == 2 &
                cells[0][2] == 3 &
                cells[0][3] == 4 &
                cells[1][0] == 5 &
                cells[1][1] == 6 &
                cells[1][2] == 7 &
                cells[1][3] == 8 &
                cells[2][0] == 9 &
                cells[2][1] == 10 &
                cells[2][2] == 11 &
                cells[2][3] == 12 &
                cells[3][0] == 13 &
                cells[3][1] == 14 &
                cells[3][2] == 15 &
                cells[3][3] == 0;

// An example cover property for checking that a solution can be reached
c: cover property (@(posedge clk) solution);

// Instructions:
// 1. Implement "property P;" below.
// 2. Use auxiliary code if needed.
// 3. Do not change the name of the property (keep it "P").
// 4. Do not change the label of the assert (keep it "A").
// 5. You are allowed to make changes to the module above so long as these
//    changes do not alter the transition rules of the puzzle.

// IMPLEMENT THE AUXILIARY CODE HERE IF NEEDED
reg [15:0] enteredd;

logic movValid;
logic [1:0] xindx, yindx;

function automatic [3:0] idx(input logic [1:0] x, input logic [1:0] y);
  idx = {x,2'b00} + y; // x*4 + y what weve indexed 
endfunction

always @(*) begin
  xindx = empty_x;
  yindx = empty_y;
  movValid = 1'b0;
  case (direction)// we check valid movves 
    2'b00: if (empty_y > 0) begin yindx = empty_y - 1; movValid = 1'b1; end // left
    2'b11: if (empty_x < 3) begin xindx = empty_x + 1; movValid = 1'b1; end // down
    2'b10: if (empty_x > 0) begin xindx = empty_x - 1; movValid = 1'b1; end // up
    2'b01: if (empty_y < 3) begin yindx = empty_y + 1; movValid = 1'b1; end // right 
  endcase
end

always @ (posedge clk) begin
  if (~rst) begin
  //we initialize the bitmap
  enteredd <= 16'b0;
  enteredd[idx(2'd0,2'd0)] <= 1'b1;  // starting square (0,0) enteredd
  end else begin
  if (movValid)//here we just put 1 in bitwise or where the index we visited 
  enteredd <= enteredd | (16'b1 << idx(xindx, yindx));
  end
end

property P;
    @(posedge clk) ##[0:$] (solution && (enteredd == 16'hFFFF)); // IMPLEMENT THE PROPERTY HERE
endproperty

A: cover property (P);

endmodule
