module tb_dff;

reg clk;
reg d;
wire q;

initial begin
    $from_myhdl(
        clk,
        d
    );
    $to_myhdl(
        q
    );
end

dff dut(
    clk,
    d,
    q
);

endmodule
