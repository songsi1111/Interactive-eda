#include "adder_fp8"
#include "multiplier_fp8"
#include "sigmoid_8"
module a()
input i0_1,i0_2,i0_3,i0_4,i0_5,i0_6,i0_7,i0_8;
input i1_1,i1_2,i1_3,i1_4,i1_5,i1_6,i1_7,i1_8;
output o0_1,o0_2,o0_3,o0_4,o0_5,o0_6,o0_7,o0_8;
	multiplier_fp8(i0_1,i0_2,i0_3,i0_4,i0_5,i0_6,i0_7,i0_8,i1_1,i1_2,i1_3,i1_4,i1_5,i1_6,i1_7,i1_8,o0_1,o0_2,o0_3,o0_4,o0_5,o0_6,o0_7,o0_8);
endmodule
module b()
input i0_1,i0_2,i0_3,i0_4,i0_5,i0_6,i0_7,i0_8;
input i1_1,i1_2,i1_3,i1_4,i1_5,i1_6,i1_7,i1_8,i1_9,i1_10,i1_11,i1_12,i1_13,i1_14,i1_15,i1_16;
wire w0_1,w0_2,w0_3,w0_4,w0_5,w0_6,w0_7,w0_8;
	a(i1_1,i1_2,i1_3,i1_4,i1_5,i1_6,i1_7,i1_8,i1_9,i1_10,i1_11,i1_12,i1_13,i1_14,i1_15,i1_16,w0_1,w0_2,w0_3,w0_4,w0_5,w0_6,w0_7,w0_8);
output o0_1,o0_2,o0_3,o0_4,o0_5,o0_6,o0_7,o0_8;
	adder_fp8(i0_1,i0_2,i0_3,i0_4,i0_5,i0_6,i0_7,i0_8,w0_1,w0_2,w0_3,w0_4,w0_5,w0_6,w0_7,w0_8,o0_1,o0_2,o0_3,o0_4,o0_5,o0_6,o0_7,o0_8);
endmodule
module c()
input i0_1,i0_2,i0_3,i0_4,i0_5,i0_6,i0_7,i0_8,i0_9,i0_10,i0_11,i0_12,i0_13,i0_14,i0_15,i0_16,i0_17,i0_18,i0_19,i0_20,i0_21,i0_22,i0_23,i0_24;
wire w0_1,w0_2,w0_3,w0_4,w0_5,w0_6,w0_7,w0_8;
	b(i0_1,i0_2,i0_3,i0_4,i0_5,i0_6,i0_7,i0_8,i0_9,i0_10,i0_11,i0_12,i0_13,i0_14,i0_15,i0_16,i0_17,i0_18,i0_19,i0_20,i0_21,i0_22,i0_23,i0_24,w0_1,w0_2,w0_3,w0_4,w0_5,w0_6,w0_7,w0_8);
output o0_1,o0_2,o0_3,o0_4,o0_5,o0_6,o0_7,o0_8;
	sigmoid_8(w0_1,w0_2,w0_3,w0_4,w0_5,w0_6,w0_7,w0_8,o0_1,o0_2,o0_3,o0_4,o0_5,o0_6,o0_7,o0_8);
endmodule
