module reqgnt(
    input logic clk,
    input logic rst,
    input logic req,
    input logic gnt
);

// Instructions:
// 1. Implement "property P;" below.
// 2. Use auxiliary code.
// 3. Do not change the name of the property (keep it "P").
// 4. Do not change the label of the assert (keep it "A").

// IMPLEMENT THE AUXILIARY CODE HERE
logic [8:0] ppp;
function automatic logic [8:0] consume_one(input logic [8:0] p);
    logic [8:0] qq;
    begin
    qq = p;

    //remove oldest fro fifo 
    if      (qq[8]) qq[8] = 1'b0;
      
    else if (qq[6]) qq[6] = 1'b0;
    else if (qq[3]) qq[3] = 1'b0;
    else if (qq[4]) qq[4] = 1'b0;
      else if (qq[7]) qq[7] = 1'b0;
    else if (qq[5]) qq[5] = 1'b0;
     else if (qq[2]) qq[2] = 1'b0;

    consume_one = qq;
    end
endfunction

always_ff @(posedge clk) begin
        if (rst) begin
        ppp <= '0;
        end else begin
        logic [8:0] nx;
        // age 1 queue
        nx = {ppp[7:0], 1'b0};
        // 3 Grant consumes exactly one request in age range [2..8]
        if (gnt)
         nx = consume_one(nx);
        // new req enteredd
        if (req)
        nx[0] = 1'b1;
        ppp <= nx;
    end
end



//DEvUGGGGG
//cover property (@(posedge clk) disable iff (rst)
//    req ##2 gnt
//);

property P;
    @(posedge clk)(gnt |-> (|ppp[8:2])) and (ppp[8] |-> gnt);
endproperty // IMPLEMENT THE PROPERTY HERE


A: assert property (P);

endmodule
