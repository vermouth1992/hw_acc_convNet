module cycle_detection_pe(/*AUTOARG*/
   // Outputs
   done, cycle, addr, addr_val,
   // Inputs
   clk, rst, start, head_addr, pop_addr, din, din_val
   );
   input clk;
   input rst;
   input start;
   input [63:0] head_addr;
   input 	pop_addr;
   
   output done;
   output cycle;
   output [63:0] addr;
   output 	 addr_val;
   
   input [63:0]  din;
   input 	 din_val;

   reg 		 r_done,t_done;
   reg 		 r_cycle,t_cycle;
   reg [63:0] 	 r_addr,t_addr;
   reg 		 r_addr_val,t_addr_val;
   reg [2:0] 	 r_state,t_state;
   reg [63:0] 	 r_ptr2x, r_ptr1x;
   reg [63:0] 	 t_ptr2x, t_ptr1x;

   assign done = r_done;
   assign cycle = r_cycle;

   wire 	 w_full,w_empty;
   assign addr_val = ~w_empty;
   
   fifo #(.DATA_WIDTH(64), .ADDR_WIDTH(2) ) 
   f (
      // Outputs
      .dout			(addr),
      .full			(),
      .empty			(w_empty),
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .r				(pop_addr),
      .w				(r_addr_val),
      .din				(r_addr)
      );
   
   
   
   always@(posedge clk)
     begin
    	r_done <= rst ? 1'b0 : t_done;
    	r_cycle <= rst ? 1'b0 : t_cycle;
    	r_addr <= rst ? 64'd0 : t_addr;
    	r_addr_val <= rst ? 1'b0 :t_addr_val;
    	r_state <= rst ? 'd0 : t_state;
    	r_ptr2x <= rst ? 'd0 :t_ptr2x;
    	r_ptr1x <= rst ? 'd0 :t_ptr1x;
     end

   always@(*)
     begin
    	t_done = r_done;
    	t_cycle = r_cycle;
    	t_addr = r_addr;
    	t_addr_val = 1'b0;
    	t_ptr2x = r_ptr2x;
    	t_ptr1x = r_ptr1x;
    	case(r_state)
    	  'd0:
    	    begin
    	       if(start)
    		 begin
    		    t_done = 1'b0;
    		    t_cycle = 1'b0;
    		    t_addr = head_addr;
    		    t_ptr2x = head_addr;
    		    t_ptr1x = head_addr;
    		    t_state = 'd1;
    		 end
    	       else
    		 begin
    		    t_state = 'd0;
    		 end
    	    end
    	  'd1:
    	    begin
    	       /* we're done, didn't find a cycle */
    	       if(t_ptr2x == 64'd0 || t_ptr1x == 64'd0)
    		 begin
    		    t_done = 1'b1;
    		    t_state = 'd0;
    		 end
    	       /* fetch t_ptr2x */
    	       else
    		 begin
    		    t_addr = r_ptr2x;
    		    t_addr_val = 1'b1;
    		    t_state = 'd2;
    		 end
    	    end
    	  'd2:
    	    begin
    	       /* ptr2x is valid */
    	       if(din_val)
    		 begin
    		    t_ptr2x = din;
    		    //$display("got ptr2x=%d\n", din);
    		    /*null ptr, we're done (no cycle) */
    		    if(din == 64'd0)
    		      begin
    			 t_done = 1'b1;
    			 t_state = 'd0;
    		      end
    		    else
    		      begin
    			 t_state = 'd3;
    		      end
    		 end // if (din_val)
    	       else
    		 begin
    		    /*wait for ptr2x */
    		    t_state = 'd2;
    		 end
    	    end
    	  'd3:
    	    begin
    	       /*check if pointers match (found cycle) */
    	       if(r_ptr2x == r_ptr1x)
    		 begin
    		    t_done = 1'b1;
    		    t_cycle = 1'b1;
    		    t_state = 'd0;
    		 end
    	       else
    		 begin
    		    /* fetch ptr1x for next iteration */
    		    t_addr = r_ptr1x;
    		    t_addr_val = 1'b1;
    		    t_state = 'd4;
    		 end
    	    end // case: 'd3
    	  'd4:
    	    begin
    	       t_addr = r_ptr2x;
    	       t_addr_val = 1'b1;
    	       t_state = 'd5;
    	    end
    	  'd5:
    	    begin
    	       if(din_val)
    		 begin
    		    t_ptr1x = din;
    		    //$display("got ptr1x=%d\n", din);
    		    t_state = 'd6;
    		 end // if (din_val)
    	       else
    		 begin
    		    /* wait for data */
    		    t_state = 'd5;
    		 end
    	    end // case: 'd5
    	  'd6:
    	    begin
    	       if(din_val)
    		 begin
    		    t_ptr2x = din;
    		    //$display("got ptr2x=%d\n", din);
    		    t_state = 'd1;
    		 end
    	       else
    		 begin
    		    t_state = 'd6;
    		 end
    	    end // case: 'd6
    	  default:
    	    begin
    	       t_state ='d0;
    	    end
    	endcase
     end // always@ (*)
   

   
endmodule // cycle_detection_pe

   
