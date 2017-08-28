module blk_ram(clk,wen,addr,din,dout);

    parameter DATA_WIDTH = 32;
    parameter MEM_ADDR_WIDTH = 6;
    parameter SIZE_RAM = 1<<MEM_ADDR_WIDTH;

    input clk,wen;
    input[MEM_ADDR_WIDTH-1:0] addr;
    input[DATA_WIDTH-1:0] din;
    output reg[DATA_WIDTH-1:0] dout;

    reg[DATA_WIDTH-1:0] ram[SIZE_RAM-1:0];

    always@(posedge clk)
    begin
        if (wen) begin
            ram[addr] <= din;
        end
        dout <= ram[addr];
        
    end
endmodule


module spn(clk,rst,input_stream,output_stream,valid_in,valid_out);
    parameter PARA = 32;
    parameter MEM_DEPTH = 8;

    localparam SEL_WIDTH = $log2(PARA);  // data width for one mux sel signal
    localparam MEM_ADDR_WIDTH = $log2(MEM_DEPTH);   // log(MEM_DEPTH,2)

    input clk,rst,valid_in;
    input[DATA_WIDTH-1:0] input_stream[PARA-1:0];
    output valid_out;
    output[DATA_WIDTH-1:0] output_stream[PARA-1:0];

    reg[DATA_WIDTH-1:0] output_stream_reg[PARA-1:0];
    reg[DATA_WIDTH-1:0] input_delay0[PARA-1:0];
    reg[DATA_WIDTH-1:0] mem_delay1[PARA-1:0];
    reg[DATA_WIDTH-1:0] mem_output[PARA-1:0];
    reg[DATA_WIDTH-1:0] output_delay2[PARA-1:0];
    reg[DATA_WIDTH-1:0] mem_input[PARA-1:0];
    
    reg valid_mem_in,valid_perm2_in;
    reg valid_delay0,valid_delay1,valid_out_reg;
    
    reg[SEL_WIDTH:0] i;
    // [BEGIN] VAR DEF
    // width for one mem addr, or mux sel signal
    reg[2:0] mem_addr[31:0];     // stage1: temp perm
    reg[4:0] sel_perm0[31:0];    // stage0: spatial perm
    reg[4:0] sel_perm2[31:0];    // stage2: spatial perm


    // counter used for traversing control_* (simply add 1 each cycle)
    reg[2:0] counter_mem_addr_0;
    reg[2:0] counter_mem_addr_1;
    reg[3:0] counter_mem_addr_2;
    reg[3:0] counter_mem_addr_3;
    reg[3:0] counter_mem_addr_4;
    reg[3:0] counter_mem_addr_5;
    reg[3:0] counter_mem_addr_6;
    reg[3:0] counter_mem_addr_7;
    reg[3:0] counter_mem_addr_8;
    reg[3:0] counter_mem_addr_9;
    reg[3:0] counter_mem_addr_10;
    reg[3:0] counter_mem_addr_11;
    reg[3:0] counter_mem_addr_12;
    reg[3:0] counter_mem_addr_13;
    reg[3:0] counter_mem_addr_14;
    reg[3:0] counter_mem_addr_15;
    reg[2:0] counter_mem_addr_16;
    reg[2:0] counter_mem_addr_17;
    reg[3:0] counter_mem_addr_18;
    reg[3:0] counter_mem_addr_19;
    reg[3:0] counter_mem_addr_20;
    reg[3:0] counter_mem_addr_21;
    reg[3:0] counter_mem_addr_22;
    reg[3:0] counter_mem_addr_23;
    reg[3:0] counter_mem_addr_24;
    reg[3:0] counter_mem_addr_25;
    reg[3:0] counter_mem_addr_26;
    reg[3:0] counter_mem_addr_27;
    reg[3:0] counter_mem_addr_28;
    reg[3:0] counter_mem_addr_29;
    reg[3:0] counter_mem_addr_30;
    reg[3:0] counter_mem_addr_31;

    reg[2:0] counter_perm0;
    reg[2:0] counter_perm2;


    // actual control bits
    reg[23:0] control_mem_0;
    reg[23:0] control_mem_1;
    reg[47:0] control_mem_2;
    reg[47:0] control_mem_3;
    reg[47:0] control_mem_4;
    reg[47:0] control_mem_5;
    reg[47:0] control_mem_6;
    reg[47:0] control_mem_7;
    reg[47:0] control_mem_8;
    reg[47:0] control_mem_9;
    reg[47:0] control_mem_10;
    reg[47:0] control_mem_11;
    reg[47:0] control_mem_12;
    reg[47:0] control_mem_13;
    reg[47:0] control_mem_14;
    reg[47:0] control_mem_15;
    reg[23:0] control_mem_16;
    reg[23:0] control_mem_17;
    reg[47:0] control_mem_18;
    reg[47:0] control_mem_19;
    reg[47:0] control_mem_20;
    reg[47:0] control_mem_21;
    reg[47:0] control_mem_22;
    reg[47:0] control_mem_23;
    reg[47:0] control_mem_24;
    reg[47:0] control_mem_25;
    reg[47:0] control_mem_26;
    reg[47:0] control_mem_27;
    reg[47:0] control_mem_28;
    reg[47:0] control_mem_29;
    reg[47:0] control_mem_30;
    reg[47:0] control_mem_31;
    reg[39:0] control_perm0[31:0];
    reg[39:0] control_perm2[31:0];
    // [END] VAR DEF

    genvar g;
    generate 
    for (g=0; g<PARA; g=g+1) begin: mem_chan
      blk_ram #(.DATA_WIDTH(DATA_WIDTH),
            .MEM_ADDR_WIDTH(MEM_ADDR_WIDTH)) ram(clk,rst,valid_delay1,mem_addr[g],mem_delay1[g],mem_output[g]);
    end
    endgenerate
    assign valid_out = valid_out_reg;
    assign output_stream = output_stream_reg;
    always@(posedge clk) begin
        // need to pass in an additional image of all 0 to flush the mem stage.
        // This is ok, since it will also guarantee the 
        if (rst) begin
            // [BEGIN] VAR INIT
            counter_perm0 <= 0;
            counter_perm2 <= 0;
            counter_mem_addr_0 <= 0;
            counter_mem_addr_1 <= 0;
            counter_mem_addr_2 <= 0;
            counter_mem_addr_3 <= 0;
            control_mem_0 <= 24'b111110101100011010001000;
            control_mem_1 <= 24'b111110101100011010001000;
            control_mem_2 <= 48'b111110101100011010001000110111100101010011000001;
            control_mem_3 <= 48'b111110101100011010001000110111100101010011000001;
            control_mem_4 <= 48'b111110101100011010001000101100111110001000011010;
            control_mem_5 <= 48'b111110101100011010001000101100111110001000011010;
            control_mem_6 <= 48'b111110101100011010001000100101110111000001010011;
            control_mem_7 <= 48'b111110101100011010001000100101110111000001010011;
            control_mem_8 <= 48'b111110101100011010001000011010001000111110101100;
            control_mem_9 <= 48'b111110101100011010001000011010001000111110101100;
            control_mem_10 <= 48'b111110101100011010001000010011000001110111100101;
            control_mem_11 <= 48'b111110101100011010001000010011000001110111100101;
            control_mem_12 <= 48'b111110101100011010001000001000011010101100111110;
            control_mem_13 <= 48'b111110101100011010001000001000011010101100111110;
            control_mem_14 <= 48'b111110101100011010001000000001010011100101110111;
            control_mem_15 <= 48'b111110101100011010001000000001010011100101110111;
            control_mem_16 <= 24'b111110101100011010001000;
            control_mem_17 <= 24'b111110101100011010001000;
            control_mem_18 <= 48'b111110101100011010001000110111100101010011000001;
            control_mem_19 <= 48'b111110101100011010001000110111100101010011000001;
            control_mem_20 <= 48'b111110101100011010001000101100111110001000011010;
            control_mem_21 <= 48'b111110101100011010001000101100111110001000011010;
            control_mem_22 <= 48'b111110101100011010001000100101110111000001010011;
            control_mem_23 <= 48'b111110101100011010001000100101110111000001010011;
            control_mem_24 <= 48'b111110101100011010001000011010001000111110101100;
            control_mem_25 <= 48'b111110101100011010001000011010001000111110101100;
            control_mem_26 <= 48'b111110101100011010001000010011000001110111100101;
            control_mem_27 <= 48'b111110101100011010001000010011000001110111100101;
            control_mem_28 <= 48'b111110101100011010001000001000011010101100111110;
            control_mem_29 <= 48'b111110101100011010001000001000011010101100111110;
            control_mem_30 <= 48'b111110101100011010001000000001010011100101110111;
            control_mem_31 <= 48'b111110101100011010001000000001010011100101110111;

            control_perm0[0] <= 40'b0111001100010100100000110001000001000000;
            control_perm0[1] <= 40'b0111101101010110100100111001010001100001;
            control_perm0[2] <= 40'b0110001110010000101000100001100000000010;
            control_perm0[3] <= 40'b0110101111010010101100101001110000100011;
            control_perm0[4] <= 40'b0101001000011100110000010000000011000100;
            control_perm0[5] <= 40'b0101101001011110110100011000010011100101;
            control_perm0[6] <= 40'b0100001010011000111000000000100010000110;
            control_perm0[7] <= 40'b0100101011011010111100001000110010100111;
            control_perm0[8] <= 40'b0011000100000100000001110011000101001000;
            control_perm0[9] <= 40'b0011100101000110000101111011010101101001;
            control_perm0[10] <= 40'b0010000110000000001001100011100100001010;
            control_perm0[11] <= 40'b0010100111000010001101101011110100101011;
            control_perm0[12] <= 40'b0001000000001100010001010010000111001100;
            control_perm0[13] <= 40'b0001100001001110010101011010010111101101;
            control_perm0[14] <= 40'b0000000010001000011001000010100110001110;
            control_perm0[15] <= 40'b0000100011001010011101001010110110101111;
            control_perm0[16] <= 40'b1111011100110101100010110101001001010000;
            control_perm0[17] <= 40'b1111111101110111100110111101011001110001;
            control_perm0[18] <= 40'b1110011110110001101010100101101000010010;
            control_perm0[19] <= 40'b1110111111110011101110101101111000110011;
            control_perm0[20] <= 40'b1101011000111101110010010100001011010100;
            control_perm0[21] <= 40'b1101111001111111110110011100011011110101;
            control_perm0[22] <= 40'b1100011010111001111010000100101010010110;
            control_perm0[23] <= 40'b1100111011111011111110001100111010110111;
            control_perm0[24] <= 40'b1011010100100101000011110111001101011000;
            control_perm0[25] <= 40'b1011110101100111000111111111011101111001;
            control_perm0[26] <= 40'b1010010110100001001011100111101100011010;
            control_perm0[27] <= 40'b1010110111100011001111101111111100111011;
            control_perm0[28] <= 40'b1001010000101101010011010110001111011100;
            control_perm0[29] <= 40'b1001110001101111010111011110011111111101;
            control_perm0[30] <= 40'b1000010010101001011011000110101110011110;
            control_perm0[31] <= 40'b1000110011101011011111001110111110111111;

            control_perm2[0] <= 40'b0111001100010100100000110001000001000000;
            control_perm2[1] <= 40'b1111011100110101100010110101001001010000;
            control_perm2[2] <= 40'b0110001110010000101000100001100000000010;
            control_perm2[3] <= 40'b1110011110110001101010100101101000010010;
            control_perm2[4] <= 40'b0101001000011100110000010000000011000100;
            control_perm2[5] <= 40'b1101011000111101110010010100001011010100;
            control_perm2[6] <= 40'b0100001010011000111000000000100010000110;
            control_perm2[7] <= 40'b1100011010111001111010000100101010010110;
            control_perm2[8] <= 40'b0011000100000100000001110011000101001000;
            control_perm2[9] <= 40'b1011010100100101000011110111001101011000;
            control_perm2[10] <= 40'b0010000110000000001001100011100100001010;
            control_perm2[11] <= 40'b1010010110100001001011100111101100011010;
            control_perm2[12] <= 40'b0001000000001100010001010010000111001100;
            control_perm2[13] <= 40'b1001010000101101010011010110001111011100;
            control_perm2[14] <= 40'b0000000010001000011001000010100110001110;
            control_perm2[15] <= 40'b1000010010101001011011000110101110011110;
            control_perm2[16] <= 40'b0111101101010110100100111001010001100001;
            control_perm2[17] <= 40'b1111111101110111100110111101011001110001;
            control_perm2[18] <= 40'b0110101111010010101100101001110000100011;
            control_perm2[19] <= 40'b1110111111110011101110101101111000110011;
            control_perm2[20] <= 40'b0101101001011110110100011000010011100101;
            control_perm2[21] <= 40'b1101111001111111110110011100011011110101;
            control_perm2[22] <= 40'b0100101011011010111100001000110010100111;
            control_perm2[23] <= 40'b1100111011111011111110001100111010110111;
            control_perm2[24] <= 40'b0011100101000110000101111011010101101001;
            control_perm2[25] <= 40'b1011110101100111000111111111011101111001;
            control_perm2[26] <= 40'b0010100111000010001101101011110100101011;
            control_perm2[27] <= 40'b1010110111100011001111101111111100111011;
            control_perm2[28] <= 40'b0001100001001110010101011010010111101101;
            control_perm2[29] <= 40'b1001110001101111010111011110011111111101;
            control_perm2[30] <= 40'b0000100011001010011101001010110110101111;
            control_perm2[31] <= 40'b1000110011101011011111001110111110111111;
            // [END] VAR INIT

            valid_mem_in <= 0;
            valid_perm2_in <= 0;
            valid_delay0 <= 0;
            valid_delay1 <= 0;
            valid_out_reg <= 0;
        end else begin
            // if in this cycle, the data is valid, then we need to pass-in
            // valid_in to be 1 the cycle before
            valid_delay0 <= valid_in;   // delay for 1 clk
            valid_mem_in <= valid_delay0;
            valid_delay1 <= valid_mem_in;
            valid_perm2_in <= valid_delay1;
            valid_out_reg <= valid_perm2_in;// i will output one wasted image of N x N
                                        // but it is all 0, so it won't affec
                                        
            if (valid_in) begin
            // perm0: get control signal
                counter_perm0 <= counter_perm0+1;
                for (i=0; i<PARA; i=i+1) begin
                    sel_perm0[i] <= control_perm0[i][counter_perm0*SEL_WIDTH+:SEL_WIDTH];
                end
                input_delay0 <= input_stream;
            end
            if (valid_delay0) begin
            // perm0: mux
                for (i=0; i<PARA; i=i+1)
                    mem_input[i] <= input_delay0[sel_perm0[i]];
            end
            if (valid_mem_in) begin
            // mem: get control signal
                counter_mem_addr_0 <= counter_mem_addr_0+1;
                counter_mem_addr_1 <= counter_mem_addr_1+1;
                counter_mem_addr_2 <= counter_mem_addr_2+1;
                counter_mem_addr_3 <= counter_mem_addr_3+1;
                counter_mem_addr_4 <= counter_mem_addr_4+1;
                counter_mem_addr_5 <= counter_mem_addr_5+1;
                counter_mem_addr_6 <= counter_mem_addr_6+1;
                counter_mem_addr_7 <= counter_mem_addr_7+1;
                counter_mem_addr_8 <= counter_mem_addr_8+1;
                counter_mem_addr_9 <= counter_mem_addr_9+1;
                counter_mem_addr_10 <= counter_mem_addr_10+1;
                counter_mem_addr_11 <= counter_mem_addr_11+1;
                counter_mem_addr_12 <= counter_mem_addr_12+1;
                counter_mem_addr_13 <= counter_mem_addr_13+1;
                counter_mem_addr_14 <= counter_mem_addr_14+1;
                counter_mem_addr_15 <= counter_mem_addr_15+1;
                counter_mem_addr_16 <= counter_mem_addr_16+1;
                counter_mem_addr_17 <= counter_mem_addr_17+1;
                counter_mem_addr_18 <= counter_mem_addr_18+1;
                counter_mem_addr_19 <= counter_mem_addr_19+1;
                counter_mem_addr_20 <= counter_mem_addr_20+1;
                counter_mem_addr_21 <= counter_mem_addr_21+1;
                counter_mem_addr_22 <= counter_mem_addr_22+1;
                counter_mem_addr_23 <= counter_mem_addr_23+1;
                counter_mem_addr_24 <= counter_mem_addr_24+1;
                counter_mem_addr_25 <= counter_mem_addr_25+1;
                counter_mem_addr_26 <= counter_mem_addr_26+1;
                counter_mem_addr_27 <= counter_mem_addr_27+1;
                counter_mem_addr_28 <= counter_mem_addr_28+1;
                counter_mem_addr_29 <= counter_mem_addr_29+1;
                counter_mem_addr_30 <= counter_mem_addr_30+1;
                counter_mem_addr_31 <= counter_mem_addr_31+1;

                mem_addr[0] <= control_mem_0[counter_mem_addr_0*MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH];
                mem_addr[1] <= control_mem_1[counter_mem_addr_1*MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH];
                mem_addr[2] <= control_mem_2[counter_mem_addr_2*MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH];
                mem_addr[3] <= control_mem_3[counter_mem_addr_3*MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH];
                mem_addr[4] <= control_mem_4[counter_mem_addr_4*MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH];
                mem_addr[5] <= control_mem_5[counter_mem_addr_5*MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH];
                mem_addr[6] <= control_mem_6[counter_mem_addr_6*MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH];
                mem_addr[7] <= control_mem_7[counter_mem_addr_7*MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH];
                mem_addr[8] <= control_mem_8[counter_mem_addr_8*MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH];
                mem_addr[9] <= control_mem_9[counter_mem_addr_9*MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH];
                mem_addr[10] <= control_mem_10[counter_mem_addr_10*MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH];
                mem_addr[11] <= control_mem_11[counter_mem_addr_11*MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH];
                mem_addr[12] <= control_mem_12[counter_mem_addr_12*MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH];
                mem_addr[13] <= control_mem_13[counter_mem_addr_13*MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH];
                mem_addr[14] <= control_mem_14[counter_mem_addr_14*MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH];
                mem_addr[15] <= control_mem_15[counter_mem_addr_15*MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH];
                mem_addr[16] <= control_mem_16[counter_mem_addr_16*MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH];
                mem_addr[17] <= control_mem_17[counter_mem_addr_17*MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH];
                mem_addr[18] <= control_mem_18[counter_mem_addr_18*MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH];
                mem_addr[19] <= control_mem_19[counter_mem_addr_19*MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH];
                mem_addr[20] <= control_mem_20[counter_mem_addr_20*MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH];
                mem_addr[21] <= control_mem_21[counter_mem_addr_21*MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH];
                mem_addr[22] <= control_mem_22[counter_mem_addr_22*MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH];
                mem_addr[23] <= control_mem_23[counter_mem_addr_23*MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH];
                mem_addr[24] <= control_mem_24[counter_mem_addr_24*MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH];
                mem_addr[25] <= control_mem_25[counter_mem_addr_25*MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH];
                mem_addr[26] <= control_mem_26[counter_mem_addr_26*MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH];
                mem_addr[27] <= control_mem_27[counter_mem_addr_27*MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH];
                mem_addr[28] <= control_mem_28[counter_mem_addr_28*MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH];
                mem_addr[29] <= control_mem_29[counter_mem_addr_29*MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH];
                mem_addr[30] <= control_mem_30[counter_mem_addr_30*MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH];
                mem_addr[31] <= control_mem_31[counter_mem_addr_31*MEM_ADDR_WIDTH+:MEM_ADDR_WIDTH];

                mem_delay1 <= mem_input;
            end
            if (valid_delay1) begin
            // mem: ram module handles in/out
            end
            if (valid_perm2_in) begin
            // perm2: get control signal
                counter_perm2 <= counter_perm2+1;
                for (i=0; i<PARA; i=i+1) begin
                    sel_perm2[i] <= control_perm2[i][counter_perm2*SEL_WIDTH+:SEL_WIDTH];
            end
            output_delay2 <= mem_output;
            end
            if (valid_out) begin
                for (i=0; i<PARA; i=i+1)
                    output_stream_reg[i] <= output_delay2[sel_perm2[i]];
            end
        end
    end

endmodule
