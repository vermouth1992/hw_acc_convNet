module multfix(clk, rst, a, b, q_sc, q_unsc);
   parameter WIDTH=35, CYCLES=6;

   input signed [WIDTH-1:0]    a,b;
   output [WIDTH-1:0]          q_sc;
   output [WIDTH-1:0]              q_unsc;

   input                       clk, rst;

   reg signed [2*WIDTH-1:0]    q[CYCLES-1:0];
   wire signed [2*WIDTH-1:0]   res;
   integer                     i;

   assign                      res = q[CYCLES-1];

   assign                      q_unsc = res[WIDTH-1:0];
   assign                      q_sc = {res[2*WIDTH-1], res[2*WIDTH-4:WIDTH-2]};

   always @(posedge clk) begin
      q[0] <= a * b;
      for (i = 1; i < CYCLES; i=i+1) begin
         q[i] <= q[i-1];
      end
   end

endmodule

module addfxp(a, b, q, clk);

   parameter width = 16, cycles=1;

   input signed [width-1:0]  a, b;
   input                     clk;
   output signed [width-1:0] q;
   reg signed [width-1:0]    res[cycles-1:0];

   assign                    q = res[cycles-1];

   integer                   i;

   always @(posedge clk) begin
     res[0] <= a+b;
      for (i=1; i < cycles; i = i+1)
        res[i] <= res[i-1];

   end

endmodule

module subfxp(a, b, q, clk);

   parameter width = 16, cycles=1;

   input signed [width-1:0]  a, b;
   input                     clk;
   output signed [width-1:0] q;
   reg signed [width-1:0]    res[cycles-1:0];

   assign                    q = res[cycles-1];

   integer                   i;

   always @(posedge clk) begin
     res[0] <= a-b;
      for (i=1; i < cycles; i = i+1)
        res[i] <= res[i-1];

   end

endmodule
