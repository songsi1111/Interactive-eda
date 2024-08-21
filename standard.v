module and()
input A, B;
output Y;
    pmos(Y, GND,A);
    nmos(Y, B, A);
endmodule

module or()
input A, B;
output Y;
    pmos(Y, B, A);
    nmos(Y, VCC, A);
endmodule

module not()
input   A;
output  Y;
    pmos(Y, VCC, A);
    nmos(Y, GND, A);
endmodule

module buf()
input   A;
output  Y;
    pmos(Y, A, GND);
endmodule

module xor()
input A, B;
output Y;
wire tmp1;
    pmos(tmp1, VCC, B);
    nmos(tmp1, GND, B);
    
    pmos(Y, B, A);
    nmos(Y, tmp1, A);
endmodule

module xnor()
input A, B;
output Y;
wire tmp1;
    xor(A,B,tmp1);
    not(tmp1,Y);
endmodule

module adder_f()
input A, B, Cin;
output D, Cout;
wire tmp_xor;
    xor(A, B, tmp_xor);
    xor(Cin, tmp_xor, D);
    pmos(Cout,A,tmp_xor);
    nmos(Cout,Cin,tmp_xor);
endmodule

module adder2()
input x_1,x2,y1,y2, Cin;
output z_1,z2, Cout;
wire c1;
    adder_f(x2,y2,Cin,z2,c1);
    adder_f(x_1,y1,c1,z_1,Cout);
endmodule

module adder4()
input a1,a2,a3,a4,b1,b2,b3,b4;
output o1,o2,o3,o4;
wire c2,c4;
    adder2(a3,a4,b3,b4,GND,o3,o4,c2);
    adder2(a1,a2,b1,b2,c2,o1,o2,c4);
endmodule

module adder4_o()
input a1,a2,a3,a4,b1,b2,b3,b4;
output o1,o2,o3,o4,cout;
wire c2;
    adder2(a3,a4,b3,b4,GND,o3,o4,c2);
    adder2(a1,a2,b1,b2,c2,o1,o2,cout);
endmodule

module adder8()
input  a1,a2,a3,a4,a5,a6,a7,a8;
input  b1,b2,b3,b4,b5,b6,b7,b8;
output o1,o2,o3,o4,o5,o6,o7,o8;
wire c4,c3,c2,c1;
    adder2(a7,a8,b7,b8,GND,o7,o8,c4);
    adder2(a5,a6,b5,b6,c4,o5,o6,c3);
    adder2(a3,a4,b3,b4,c3,o3,o4,c2);
    adder2(a1,a2,b1,b2,c2,o1,o2,c1);
endmodule

module subtractor()
    input A, B, Bin;
    output D, Bout;
    wire tmp_xor, tmp_and_1,tmp_and_2, A_not,BC_and;
    
    xor(A, B, tmp_xor);
    xor(Bin, tmp_xor, D);
    
    not(A,A_not);
    and(B,Bin,BC_and);
    and(A_not, B,tmp_and_1);
    and(A_not, Bin,tmp_and_2);

    wire tmp_and;
    or(tmp_and_1,tmp_and_2, tmp_and);
    or(tmp_and,BC_and,Bout);
endmodule

module subtractor2()
    input x_1, x2, y1, y2, Bin;
    output z_1, z2, Bout;
    wire b1;
    
    subtractor(x2, y2, Bin, z2, b1);
    subtractor(x_1, y1, b1, z_1, Bout);
endmodule

module subtractor4()
    input a1, a2, a3, a4, b1, b2, b3, b4;
    output o1, o2, o3, o4;
    wire br2, br4;
    
    subtractor2(a3, a4, b3, b4, GND, o3, o4, br2);
    subtractor2(a1, a2, b1, b2, br2, o1, o2, br4);
endmodule

module comparator_gt_1()
input a, b;
output gt;
    wire b_not;
    not(b, b_not);
    and(a, b_not, gt);
endmodule

module comparator_eq_1()
input a, b;
output eq;
wire neq;
    xor(a, b, neq);
    not(neq,eq); 
endmodule

module comparator_eq_4 ()
input a1,a2,a3,a4,b1,b2,b3,b4;
output eq;
wire eq1,eq2,eq3,eq4;
    comparator_eq_1(a1, b1, eq1);
    comparator_eq_1(a2, b2, eq2);
    comparator_eq_1(a3, b3, eq3);
    comparator_eq_1(a4, b4, eq4);

    wire eq12,eq123;
    and(eq1,eq2,eq12);
    and(eq12,eq3,eq123);
    and(eq123,eq4,eq);
endmodule

module comparator_gt_4 ()
input a1,a2,a3,a4,b1,b2,b3,b4;
output gt;
wire gt1, gt2, gt3, gt4;
wire eq1,eq2,eq3;
    comparator_gt_1(a1,b1,gt1);
    comparator_gt_1(a2,b2,gt2);
    comparator_gt_1(a3,b3,gt3);
    comparator_gt_1(a4,b4,gt4);
    
    comparator_eq_1(a1, b1, eq1);
    comparator_eq_1(a2, b2, eq2);
    comparator_eq_1(a3, b3, eq3);

    wire gt3_and_a3_not,gt2_and_a3_not_a2_not,gt1_and_a3_not_a2_not_a1_not;
    and(gt2, eq1 ,gt3_and_a3_not);

    wire tmp_and_1;
    and(gt3, eq1,tmp_and_1);
    and(tmp_and_1, eq2, gt2_and_a3_not_a2_not);

    wire tmp_and_2,tmp_and_3;
    and(gt4, eq1,tmp_and_2);
    and(tmp_and_2,eq2,tmp_and_3);
    and(tmp_and_3,eq3,gt1_and_a3_not_a2_not_a1_not);

    wire gt_or_gt3,gt_or_gt2;
    or(gt1, gt3_and_a3_not,gt_or_gt3);
    or(gt_or_gt3, gt2_and_a3_not_a2_not,gt_or_gt2);
    or(gt_or_gt2, gt1_and_a3_not_a2_not_a1_not,gt);

endmodule

module comparator_gt_8 ()
input a1,a2,a3,a4,a5,a6,a7,a8,b1,b2,b3,b4,b5,b6,b7,b8;
output gt;
    wire gt1, gt2;
    wire eq;
    comparator_gt_4(a1,a2,a3,a4,b1,b2,b3,b4,gt1);
    comparator_gt_4(a5,a6,a7,a8,b5,b6,b7,b8,gt2);
    comparator_eq_4(a1,a2,a3,a4,b1,b2,b3,b4,eq);

    wire eq_and_gt2;
    and(eq,gt2,eq_and_gt2);
    or(gt1,eq_and_gt2,gt);
endmodule

module chooser_1()
input x,y,gt;
output e;
    wire gt_not;
    not(gt,gt_not);

    wire x_gt,y_gt;
    and(x,gt,x_gt);
    and(y,gt_not,y_gt);
    or(x_gt,y_gt,e);
endmodule

module chooser_4()
input x1,x2,x3,x4,y1,y2,y3,y4;
input gt;
output e1, e2, e3, e4;
    chooser_1(x1,y1,gt,e1);
    chooser_1(x2,y2,gt,e2);
    chooser_1(x3,y3,gt,e3);
    chooser_1(x4,y4,gt,e4);
endmodule

module chooser_8()
input x1,x2,x3,x4,x5,x6,x7,x8,y1,y2,y3,y4,y5,y6,y7,y8;
input gt;
output e1, e2, e3, e4, e5, e6, e7, e8;
    chooser_4(x1,x2,x3,x4,y1,y2,y3,y4,gt,e1, e2, e3, e4);
    chooser_4(x5,x6,x7,x8,y5,y6,y7,y8,gt,e5, e6, e7, e8);
endmodule

module max_1()
input x,y;
output z;
    or(x,y,z);
endmodule

module shifter_right_1()
input x1,x2,x3,x4,s;
output o1, o2, o3, o4;
    wire t1,t2,t3,t4;
    buf(GND,t1);
    buf(x1,t2);
    buf(x2,t3);
    buf(x3,t4);
    chooser_4(t1,t2,t3,t4,x1,x2,x3,x4,s,o1,o2,o3,o4);
endmodule

module shifter_left_1_8()
input x1,x2,x3,x4,x5,x6,x7,x8,s;
output o1,o2,o3,o4,o5,o6,o7,o8;
    wire t1,t2,t3,t4,t5,t6,t7,t8;
    buf(GND,t8);
    buf(x8,t7);
    buf(x7,t6);
    buf(x6,t5);
    buf(x5,t4);
    buf(x4,t3);
    buf(x3,t2);
    buf(x2,t1);
    chooser_8(t1,t2,t3,t4,t5,t6,t7,t8,x1,x2,x3,x4,x5,x6,x7,x8,s,o1,o2,o3,o4,o5,o6,o7,o8);
endmodule

module shift_left_1()
input x1,x2,x3,x4,s;
output o1, o2, o3, o4;
    wire t1,t2,t3,t4;
    buf(GND,t4);
    buf(x4,t3);
    buf(x3,t2);
    buf(x2,t1);
    chooser_4(t1,t2,t3,t4,x1,x2,x3,x4,s,o1,o2,o3,o4);
endmodule

module shifter_right_4()
input x1,x2,x3,x4,s1,s2,s3,s4;
output o1, o2, o3, o4;
    wire t1_1,t1_2,t1_3,t1_4;
    wire t2_1,t2_2,t2_3,t2_4;
    wire t3_1,t3_2,t3_3,t3_4;
    wire t4_1,t4_2,t4_3,t4_4;
    
    shifter_right_1(x1,x2,x3,x4,s4,t1_1,t1_2,t1_3,t1_4);
    shifter_right_1(t1_1,t1_2,t1_3,t1_4,s3,t2_1,t2_2,t2_3,t2_4);
    shifter_right_1(t2_1,t2_2,t2_3,t2_4,s3,t3_1,t3_2,t3_3,t3_4);

    chooser_4(GND,GND,GND,GND,t3_1,t3_2,t3_3,t3_4,s2,t4_1,t4_2,t4_3,t4_4);
    chooser_4(GND,GND,GND,GND,t4_1,t4_2,t4_3,t4_4,s1,o1, o2, o3, o4);
endmodule

module buf_4()
input x1,x2,x3,x4;
output o1,o2,o3,o4;
    buf(x1,o1);
    buf(x2,o2);
    buf(x3,o3);
    buf(x4,o4);
endmodule

module leftaligner_2()
input a1,a2,a3,a4,a5,a6,a7,a8;
output o1,o2,o3,o4,o5,o6,o7,o8;
    wire y1,y2,y3,yx;
    wire z1,z2,z3,zx;
    wire x1,x2,x3,x4;
    wire q1,q2,q3,q4;
    wire gt;
    comparator_gt_4(a2,a3,a4,a5,GND,GND,VCC,GND,gt);
    wire anot_1,anot_2;
    not(a6,anot_1);
    subtractor4(a2,a3,a4,a5,GND,GND,GND,anot_1,x1,x2,x3,x4);
    shift_left_1(a6,a7,a8,GND,anot_1,y1,y2,y3,yx);
    not(y1,anot_2);
    subtractor4(x1,x2,x3,x4,GND,GND,GND,anot_2,q1,q2,q3,q4);
    shift_left_1(y1,y2,y3,yx,anot_2,z1,z2,z3,zx);
    chooser_4(q1,q2,q3,q4,a2,a3,a4,a5,gt,o2,o3,o4,o5);
    chooser_4(z1,z2,z3,GND,a6,a7,a8,GND,gt,o6,o7,o8,zx);

    buf(a1,o1);
endmodule

module leftaligner_3()
input a1,a2,a3,a4,a5,ao,a6,a7,a8;
output o1,o2,o3,o4,o5,o6,o7,o8;
    wire y1,y2,y3,y4;
    wire z1,z2,z3,z4;
    wire x1,x2,x3,x4;

    wire p1,p2,p3,p4;
    wire q1,q2,q3,q4;
    wire n1,n2,n3,n4;
    wire eq1,eq2,eq3;
    comparator_eq_4(a2,a3,a4,a5,GND,GND,GND,GND,eq1);    # equal zero #
    wire anot_1,anot_2,anot_3;
    not(ao,anot_1);
    subtractor4(a2,a3,a4,a5,GND,GND,GND,anot_1,p1,p2,p3,p4);
    shift_left_1(ao,a6,a7,a8,anot_1,y1,y2,y3,y4);
    comparator_eq_4(p1,p2,p3,p4,GND,GND,GND,GND,eq2);    # equal zero #
    
    not(y1,anot_2);
    subtractor4(p1,p2,p3,p4,GND,GND,GND,anot_2,q1,q2,q3,q4);
    shift_left_1(y1,y2,y3,y4,anot_2,z1,z2,z3,z4);
    comparator_eq_4(q1,q2,q3,q4,GND,GND,GND,GND,eq3);    # equal zero #

    not(z1,anot_3);
    subtractor4(q1,q2,q3,q4,GND,GND,GND,anot_3,n1,n2,n3,n4);
    shift_left_1(z1,z2,z3,z4,anot_3,x1,x2,x3,x4);

    wire eq12,eq123,eq;
    or(eq1,eq2,eq12);
    or(eq12,eq3,eq123);
    and(eq123,anot_1,eq);  # at least shift once #
    wire xx;
    chooser_4(GND,GND,GND,GND,n1,n2,n3,n4,eq,o2,o3,o4,o5);
    chooser_4(GND,GND,GND,GND,x2,x3,x4,GND,eq,o6,o7,o8,xx);

    buf(a1,o1);
endmodule


module adder_fp8()
input a1,a2,a3,a4,a5,a6,a7,a8,b1,b2,b3,b4,b5,b6,b7,b8;
output o1,o2,o3,o4,o5,o6,o7,o8;
    wire gt;
    comparator_gt_8(GND,a2,a3,a4,a5,a6,a7,a8,GND,b2,b3,b4,b5,b6,b7,b8,gt);
    wire x1,x2,x3,x4,y1,y2,y3,y4;
    subtractor4(a2,a3,a4,a5,b2,b3,b4,b5,x1,x2,x3,x4);
    subtractor4(b2,b3,b4,b5,a2,a3,a4,a5,y1,y2,y3,y4);
    
    # Pair #
    wire e1,e2,e3,e4;
    chooser_4(x1,x2,x3,x4,y1,y2,y3,y4,gt,e1,e2,e3,e4);  # choose the positive one #
    wire m1,m2,m3,m4,n1,n2,n3,n4;
    shifter_right_4(VCC,a6,a7,a8,e1,e2,e3,e4,m1,m2,m3,m4);
    shifter_right_4(VCC,b6,b7,b8,e1,e2,e3,e4,n1,n2,n3,n4);  # add the hide one #
    
    wire low1,low2,low3,low4,high1,high2,high3,high4;
    chooser_4(n1,n2,n3,n4,m1,m2,m3,m4,gt,low1,low2,low3,low4);
    chooser_4(VCC,a6,a7,a8,VCC,b6,b7,b8,gt,high1,high2,high3,high4);

    wire frac0,signeq;
    comparator_eq_1(a1,b1,signeq);

    wire p5,p6,p7,p8,q5,q6,q7,q8,qo;
    subtractor4(high1,high2,high3,high4,low1,low2,low3,low4,p5,p6,p7,p8);
    adder4_o(high1,high2,high3,high4,low1,low2,low3,low4,q5,q6,q7,q8,qo);

    # choose add or sub result #
    wire sign,exp1,exp2,exp3,exp4,frac1,frac2,frac3;
    wire ex1,ex2,ex3,ex4;
    wire qq5,qq6,qq7,qq8;
    chooser_4(qo,q5,q6,q7,q5,q6,q7,q8,qo,qq5,qq6,qq7,qq8);  # qo must be one,then shift #
    chooser_4(qq5,qq6,qq7,qq8,p5,p6,p7,p8,signeq,frac0,frac1,frac2,frac3);  
    chooser_4(a2,a3,a4,a5,b2,b3,b4,b5,gt,ex1,ex2,ex3,ex4);
    chooser_1(a1,b1,gt,sign);

    # if sub to zero,then set exp equal zero #
    wire frac_equal_zero;
    comparator_eq_4(frac0,frac1,frac2,frac3,GND,GND,GND,GND,frac_equal_zero);
    chooser_4(GND,GND,GND,GND,ex1,ex2,ex3,ex4,frac_equal_zero,exp1,exp2,exp3,exp4);

    # 1 plus 1 equal 10,need right_shift #
    wire expc1,expc2,expc3,expc4;
    wire carry;
    and(signeq,qo,carry);   # only when do add and have overflow,then exp plus 1 #
    adder4(exp1,exp2,exp3,exp4,GND,GND,GND,carry,expc1,expc2,expc3,expc4);

    # deal with up_overflow #
    wire zeq,zeqand;
    wire expcc1,expcc2,expcc3,expcc4,fracc0,fracc1,fracc2,fracc3;
    comparator_eq_4(expc1,expc2,expc3,expc4,GND,GND,GND,GND,zeq);
    and(zeq,signeq,zeqand);    # the up_overflow only occurs when adding #
    chooser_4(exp1,exp2,exp3,exp4,expc1,expc2,expc3,expc4,zeqand,expcc1,expcc2,expcc3,expcc4);
    chooser_4(VCC,VCC,VCC,VCC,frac0,frac1,frac2,frac3,zeqand,fracc0,fracc1,fracc2,fracc3);

    leftaligner_3(sign,expcc1,expcc2,expcc3,expcc4,fracc0,fracc1,fracc2,fracc3,o1,o2,o3,o4,o5,o6,o7,o8);
endmodule


module multiplier_4()
input a1,a2,a3,a4,b1,b2,b3,b4;
output o1,o2,o3,o4,o5,o6,o7,o8;
wire x1,x2,x3,x4,y1,y2,y3,y4,z1,z2,z3,z4,t1,t2,t3,t4;
    # prepare:n times 1 #
    chooser_4(a1,a2,a3,a4,GND,GND,GND,GND,b4,x1,x2,x3,x4);
    chooser_4(a1,a2,a3,a4,GND,GND,GND,GND,b3,y1,y2,y3,y4);
    chooser_4(a1,a2,a3,a4,GND,GND,GND,GND,b2,z1,z2,z3,z4);
    chooser_4(a1,a2,a3,a4,GND,GND,GND,GND,b1,t1,t2,t3,t4);

    wire tmp1_1,tmp1_2,tmp1_3,tmp1_4,tmp1_5,tmp1_6,tmp1_7,tmp1_8;
    wire tmp2_1,tmp2_2,tmp2_3,tmp2_4,tmp2_5,tmp2_6,tmp2_7,tmp2_8;
    adder8(GND,GND,GND,GND,x1,x2,x3,x4,GND,GND,GND,y1,y2,y3,y4,GND,tmp1_1,tmp1_2,tmp1_3,tmp1_4,tmp1_5,tmp1_6,tmp1_7,tmp1_8);
    adder8(tmp1_1,tmp1_2,tmp1_3,tmp1_4,tmp1_5,tmp1_6,tmp1_7,tmp1_8,GND,GND,z1,z2,z3,z4,GND,GND,tmp2_1,tmp2_2,tmp2_3,tmp2_4,tmp2_5,tmp2_6,tmp2_7,tmp2_8);
    adder8(tmp2_1,tmp2_2,tmp2_3,tmp2_4,tmp2_5,tmp2_6,tmp2_7,tmp2_8,GND,t1,t2,t3,t4,GND,GND,GND,o1,o2,o3,o4,o5,o6,o7,o8);
endmodule

module multiplier_fp8()
input a1,a2,a3,a4,a5,a6,a7,a8,b1,b2,b3,b4,b5,b6,b7,b8;
output o1,o2,o3,o4,o5,o6,o7,o8;
    wire sign,exp1,exp2,exp3,exp4,frac1,frac2,frac3,frac4,frac5,frac6,frac7,frac8;
    xor(a1,b1,sign);
    # exp:add,frac mul #
    wire ex1,ex2,ex3,ex4,df0,df,of0,of,ndf,nof;
    adder4(a2,a3,a4,a5,b2,b3,b4,b5,ex1,ex2,ex3,ex4);
    comparator_gt_4(VCC,GND,GND,GND,ex1,ex2,ex3,ex4,df0);  # if less than 7:downflow #
    comparator_gt_4(a2,a3,a4,a5,ex1,ex2,ex3,ex4,of0);   # if up_overflow #
    not(df0,ndf);
    and(of0,ndf,of);   # up_overflow happen and surpass than 7 # 
    not(of0,nof);
    and(df0,nof,df);   # downflow happen and no surpass flow # 
    subtractor4(ex1,ex2,ex3,ex4,GND,VCC,VCC,VCC,exp1,exp2,exp3,exp4);    # sub bias:7 #
    multiplier_4(VCC,a6,a7,a8,VCC,b6,b7,b8,frac1,frac2,frac3,frac4,frac5,frac6,frac7,frac8);    
    
    wire s1;
    not(frac1,s1);
    wire t1,t2,t3,t4,t5,t6,t7,t8;
    wire e1,e2,e3,e4;
    adder4(exp1,exp2,exp3,exp4,GND,GND,GND,frac1,e1,e2,e3,e4);  # add one to make up #
    shifter_left_1_8(frac1,frac2,frac3,frac4,frac5,frac6,frac7,frac8,s1,t1,t2,t3,t4,t5,t6,t7,t8);

    # mul_overflow #
    wire mf;
    comparator_eq_4(exp1,exp2,exp3,exp4,VCC,VCC,VCC,VCC,mf);

    # up_overflow have higher priority #
    wire set2,set3,set4,set5,set6,set7,set8,oo;
    wire m1,m2,m3,m4;
    
    chooser_4(VCC,VCC,VCC,VCC,e1,e2,e3,e4,mf,m1,m2,m3,m4); # if mulflow:choose exp_1111 #
    chooser_4(GND,GND,GND,GND,m1,m2,m3,m4,df,set2,set3,set4,set5);  # if downflow:choose _0000 # 
    chooser_4(GND,GND,GND,GND,VCC,t2,t3,t4,df,oo,set6,set7,set8); # if downflow:choose _000 # 
    chooser_4(VCC,VCC,VCC,VCC,set2,set3,set4,set5,of,o2,o3,o4,o5); # if overflow:choose exp_1111 # 
    chooser_4(VCC,VCC,VCC,VCC,oo,set6,set7,set8,of,oo,o6,o7,o8); # if overflow:choose _111 # 
    xor(a1,b1,o1);
endmodule

# if a gt b,return 1 #
module comparator_gt_fp8()
input a1,a2,a3,a4,a5,a6,a7,a8,b1,b2,b3,b4,b5,b6,b7,b8;
output gt;
    wire a1n,signgt,signeq,eq1,eq0;
    not(a1,a1n);
    and(a1n,b1,signgt);
    xnor(a1,b1,signeq);
    wire aeq1,aeq0;
    xnor(a1,VCC,aeq1);
    xnor(a1,GND,aeq0);
    and(aeq0,signeq,eq0);
    and(aeq1,signeq,eq1);

    wire agt,bgt;
    comparator_gt_8(GND,a2,a3,a4,a5,a6,a7,a8,GND,b2,b3,b4,b5,b6,b7,b8,agt);
    comparator_gt_8(GND,b2,b3,b4,b5,b6,b7,b8,GND,a2,a3,a4,a5,a6,a7,a8,bgt);

    wire gt0,gt1,gt2;
    and(eq0,agt,gt1);
    and(eq1,bgt,gt0);
    or(gt0,gt1,gt2);
    or(signgt,gt2,gt);
endmodule

# input fp8 and give fp8 #
module sigmoid_8()
input a1,a2,a3,a4,a5,a6,a7,a8;
output o1,o2,o3,o4,o5,o6,o7,o8; 
    wire tmp2_1,tmp2_2,tmp2_3,tmp2_4,tmp2_5,tmp2_6,tmp2_7,tmp2_8,tmp2_9,tmp2_10,tmp2_11,tmp2_12,tmp2_13,tmp2_14,tmp2_15,tmp2_16;
    wire t2_1,t2_2,t2_3,t2_4,t2_5,t2_6,t2_7,t2_8,t2_9,t2_10,t2_11,t2_12,t2_13,t2_14,t2_15,t2_16;
    multiplier_fp8(a1,a2,a3,a4,a5,a6,a7,a8,GND,GND,VCC,GND,VCC,GND,GND,GND,tmp2_1,tmp2_2,tmp2_3,tmp2_4,tmp2_5,tmp2_6,tmp2_7,tmp2_8);
    adder_fp8(tmp2_1,tmp2_2,tmp2_3,tmp2_4,tmp2_5,tmp2_6,tmp2_7,tmp2_8,GND,GND,VCC,VCC,VCC,GND,GND,GND,tmp2_9,tmp2_10,tmp2_11,tmp2_12,tmp2_13,tmp2_14,tmp2_15,tmp2_16);
    multiplier_fp8(tmp2_9,tmp2_10,tmp2_11,tmp2_12,tmp2_13,tmp2_14,tmp2_15,tmp2_16,tmp2_9,tmp2_10,tmp2_11,tmp2_12,tmp2_13,tmp2_14,tmp2_15,tmp2_16,t2_1,t2_2,t2_3,t2_4,t2_5,t2_6,t2_7,t2_8);
    multiplier_fp8(t2_1,t2_2,t2_3,t2_4,t2_5,t2_6,t2_7,t2_8,GND,GND,VCC,VCC,GND,GND,GND,GND,t2_9,t2_10,t2_11,t2_12,t2_13,t2_14,t2_15,t2_16);
    
    # wire res3_1,res3_2,res3_3,res3_4,res3_5,res3_6,res3_7,res3_8; #
    wire tmp3_1,tmp3_2,tmp3_3,tmp3_4,tmp3_5,tmp3_6,tmp3_7,tmp3_8,tmp3_9,tmp3_10,tmp3_11,tmp3_12,tmp3_13,tmp3_14,tmp3_15,tmp3_16;
    wire t3_1,t3_2,t3_3,t3_4,t3_5,t3_6,t3_7,t3_8,t3_9,t3_10,t3_11,t3_12,t3_13,t3_14,t3_15,t3_16;
    wire tt3_1,tt3_2,tt3_3,tt3_4,tt3_5,tt3_6,tt3_7,tt3_8;
    multiplier_fp8(a1,a2,a3,a4,a5,a6,a7,a8,VCC,GND,VCC,GND,VCC,GND,GND,GND,tmp3_1,tmp3_2,tmp3_3,tmp3_4,tmp3_5,tmp3_6,tmp3_7,tmp3_8);
    adder_fp8(tmp3_1,tmp3_2,tmp3_3,tmp3_4,tmp3_5,tmp3_6,tmp3_7,tmp3_8,GND,GND,VCC,VCC,VCC,GND,GND,GND,tmp3_9,tmp3_10,tmp3_11,tmp3_12,tmp3_13,tmp3_14,tmp3_15,tmp3_16);
    multiplier_fp8(tmp3_9,tmp3_10,tmp3_11,tmp3_12,tmp3_13,tmp3_14,tmp3_15,tmp3_16,tmp3_9,tmp3_10,tmp3_11,tmp3_12,tmp3_13,tmp3_14,tmp3_15,tmp3_16,t3_1,t3_2,t3_3,t3_4,t3_5,t3_6,t3_7,t3_8);
    multiplier_fp8(t3_1,t3_2,t3_3,t3_4,t3_5,t3_6,t3_7,t3_8,VCC,GND,VCC,VCC,GND,GND,GND,GND,t3_9,t3_10,t3_11,t3_12,t3_13,t3_14,t3_15,t3_16);
    adder_fp8(t3_9,t3_10,t3_11,t3_12,t3_13,t3_14,t3_15,t3_16,GND,GND,VCC,VCC,VCC,GND,GND,GND,tt3_1,tt3_2,tt3_3,tt3_4,tt3_5,tt3_6,tt3_7,tt3_8);

    wire ltn4,gt4,gt0;
    comparator_gt_fp8(a1,a2,a3,a4,a5,a6,a7,a8,GND,VCC,GND,GND,VCC,GND,GND,GND,gt4);
    comparator_gt_fp8(a1,a2,a3,a4,a5,a6,a7,a8,GND,GND,GND,GND,GND,GND,GND,GND,gt0);
    comparator_gt_fp8(VCC,VCC,GND,GND,VCC,GND,GND,GND,a1,a2,a3,a4,a5,a6,a7,a8,ltn4);
    wire gen4,le0,le4;
    not(ltn4,gen4);
    not(gt0,le0);
    not(gt4,le4);
    wire gen4_and_le0,gt0_and_le4;
    and(gen4,le0,gen4_and_le0);
    and(gt0,le4,gt0_and_le4);

    # choose a output #
    wire oo1,oo2,oo3,oo4,oo5,oo6,oo7,oo8;
    wire o1o,o2o,o3o,o4o,o5o,o6o,o7o,o8o;
    chooser_8(GND,GND,GND,GND,GND,GND,GND,GND, GND,GND,VCC,VCC,VCC,GND,GND,GND, ltn4,oo1,oo2,oo3,oo4,oo5,oo6,oo7,oo8);
    chooser_8(t2_9,t2_10,t2_11,t2_12,t2_13,t2_14,t2_15,t2_16,oo1,oo2,oo3,oo4,oo5,oo6,oo7,oo8,gen4_and_le0,o1o,o2o,o3o,o4o,o5o,o6o,o7o,o8o);
    chooser_8(tt3_1,tt3_2,tt3_3,tt3_4,tt3_5,tt3_6,tt3_7,tt3_8,o1o,o2o,o3o,o4o,o5o,o6o,o7o,o8o,gt0_and_le4,o1,o2,o3,o4,o5,o6,o7,o8); 

    # the test shows that the area set is no problem #
    # chooser_8(ltn4,gen4_and_le0,gt0_and_le4,gt4,GND,GND,GND,GND,o1o,o2o,o3o,o4o,o5o,o6o,o7o,o8o,VCC,o1,o2,o3,o4,o5,o6,o7,o8); #
endmodule



