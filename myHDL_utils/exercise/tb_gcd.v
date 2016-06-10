module tb_gcd;

reg clk;
reg start;
wire output;
wire ready;

initial begin
    $from_myhdl(
        clk,
        start
    );
    $to_myhdl(
        output,
        ready
    );
end

gcd dut(
    clk,
    start,
    output,
    ready
);

endmodule
