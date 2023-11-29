`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2023 04:17:57 PM
// Design Name: 
// Module Name: ready_check_fsm
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ready_check_fsm(
    input logic clk, reset, 
    input logic k_r, s_r,
    input logic [3:0] y_in, x_in,
    output logic [3:0] y_out, x_out
    );
    typedef enum {s0,s1,s2,s3,s4} state_type;
    state_type state_reg, state_next;

    always_ff @(posedge clk, posedge reset)
    begin
        if(reset)
            state_reg <= s0;
        else
            state_reg <= state_next;
    end

    always_comb
    begin
        case(state_reg)
        s0:
            if(k_r)
                state_next = s1;
            else if (s_r)
                state_next = s2;
            else
                state_next = s0;
        s1:
            if(s_r)
                state_next = s3;
            else
                state_next = s1;
        s2:
            if(k_r)
                state_next = s4;
            else
                state_next = s2;
        s3:
            state_next = s0;
        s4:
            state_next = s0;
        default: state_next = s0;
        endcase;
    end

    assign x_out = ((state_reg == s3) | (state_reg == s4)) ? x_in : 4'b0000;
    assign y_out = ((state_reg == s3) | (state_reg == s4)) ? y_in : 4'b0000;
endmodule