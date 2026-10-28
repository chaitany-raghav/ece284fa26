// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 


module mac_tb;

parameter bw = 4;
parameter psum_bw = 16;

reg clk = 0;

reg  [bw-1:0] x0, x1, x2, x3;
reg  [bw-1:0] w0, w1, w2, w3;
reg  [psum_bw-1:0] c;
wire [psum_bw-1:0] out;
reg  [psum_bw-1:0] expected_out = 0;

integer w_file ; // file handler
integer w_scan_file ; // file handler

integer x_file ; // file handler
integer x_scan_file ; // file handler

integer x_dec0, x_dec1, x_dec2, x_dec3;
integer w_dec0, w_dec1, w_dec2, w_dec3;
integer i; 
integer u; 

function [3:0] w_bin ;
  input integer  weight ;
  begin

    if (weight>-1)
     w_bin[3] = 0;
    else begin
     w_bin[3] = 1;
     weight = weight + 8;
    end

    if (weight>3) begin
     w_bin[2] = 1;
     weight = weight - 4;
    end
    else 
     w_bin[2] = 0;

    if (weight>1) begin
     w_bin[1] = 1;
     weight = weight - 2;
    end
    else 
     w_bin[1] = 0;

    if (weight>0) 
     w_bin[0] = 1;
    else 
     w_bin[0] = 0;

  end
endfunction



function [3:0] x_bin ;
  input integer  weight ;
  begin
    for (u=bw-1; u>-1; u=u-1) begin
      if (weight>2**u-1) begin
        x_bin[u] = 1;
        weight = weight - 2**u;
      end
      else begin
        x_bin[u] = 0;
      end
    end
  end
endfunction

// Below function is for verification
function [psum_bw-1:0] mac_predicted;
    input [bw-1:0] x0;
    input [bw-1:0] x1;
    input [bw-1:0] x2;
    input [bw-1:0] x3;
    input signed [bw-1:0] w0;
    input signed [bw-1:0] w1;
    input signed [bw-1:0] w2;
    input signed [bw-1:0] w3;
    input signed [psum_bw-1:0] acc_in;

    reg signed [bw:0] x0_s, x1_s, x2_s, x3_s;
    reg signed [2*bw:0] p0, p1, p2, p3;

    begin
        x0_s = $signed({1'b0, x0});
        x1_s = $signed({1'b0, x1});
        x2_s = $signed({1'b0, x2});
        x3_s = $signed({1'b0, x3});

        p0 = x0_s * w0;
        p1 = x1_s * w1;
        p2 = x2_s * w2;
        p3 = x3_s * w3;

        mac_predicted = acc_in + p0 + p1 + p2 + p3;
    end
endfunction


mac_wrapper #(.bw(bw), .psum_bw(psum_bw)) mac_wrapper_instance (
        .clk(clk), 
        .x0(x0), .x1(x1), .x2(x2), .x3(x3),
        .w0(w0), .w1(w1), .w2(w2), .w3(w3),
        .c(c),
        .out(out)
); 
 

initial begin 
  w_file = $fopen("b_data.txt", "r");  //weight data
  x_file = $fopen("a_data.txt", "r");  //activation

  $dumpfile("mac_tb.vcd");
  $dumpvars(0,mac_tb);
 
  #1 clk = 1'b0;  
  #1 clk = 1'b1;  
  #1 clk = 1'b0;

  $display("-------------------- Computation start --------------------");
  

  for (i=0; i<5; i=i+1) begin  

     #1 clk = 1'b1;
     #1 clk = 1'b0;

     w_scan_file = $fscanf(w_file, "%d\n", w_dec0);
     w_scan_file = $fscanf(w_file, "%d\n", w_dec1);
     w_scan_file = $fscanf(w_file, "%d\n", w_dec2);
     w_scan_file = $fscanf(w_file, "%d\n", w_dec3);

     x_scan_file = $fscanf(x_file, "%d\n", x_dec0);
     x_scan_file = $fscanf(x_file, "%d\n", x_dec1);
     x_scan_file = $fscanf(x_file, "%d\n", x_dec2);
     x_scan_file = $fscanf(x_file, "%d\n", x_dec3);

     x0 = x_bin(x_dec0); 
     x1 = x_bin(x_dec1); 
     x2 = x_bin(x_dec2); 
     x3 = x_bin(x_dec3); 

     w0 = w_bin(w_dec0); 
     w1 = w_bin(w_dec1); 
     w2 = w_bin(w_dec2); 
     w3 = w_bin(w_dec3); 

     c = expected_out;

     expected_out = mac_predicted(x0, x1, x2, x3, w0, w1, w2, w3, c);

  end



  #1 clk = 1'b1;
  #1 clk = 1'b0;

  $display("-------------------- Computation completed --------------------");

  #10 $finish;


end

endmodule