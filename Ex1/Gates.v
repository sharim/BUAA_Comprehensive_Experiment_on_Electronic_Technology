module andGate(
	 input [1:0] in,
	 output out
);
	 assign out = & in;
endmodule // 与门

module orGate(
	 input [1:0] in,
	 output out
);
	 assign out = | in;
endmodule // 或门

module notGate(
	 input in,
	 output out
);
	 assign out = ~in;
endmodule // 非门

module nandGate(
	 input [1:0] in,
	 output out
);
	 assign out = ~(& in);
endmodule // 与非门

module aoiGate(
	 input [3:0] in,
	 output out
);
	assign out = ~(&in[3:2] | &in[1:0]);
endmodule // 与或非门

module xorGate(
	 input [1:0] in,
	 output out
);
	 assign out = ^in;
endmodule // 异或门