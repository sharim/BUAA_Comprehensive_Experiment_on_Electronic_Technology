library verilog;
use verilog.vl_types.all;
entity Ex1_tb is
    generic(
        PERIOD          : integer := 10;
        N               : integer := 2;
        width           : integer := 2
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of PERIOD : constant is 1;
    attribute mti_svvh_generic_type of N : constant is 1;
    attribute mti_svvh_generic_type of width : constant is 1;
end Ex1_tb;
