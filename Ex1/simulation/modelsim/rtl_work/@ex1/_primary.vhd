library verilog;
use verilog.vl_types.all;
entity Ex1 is
    port(
        \in\            : in     vl_logic_vector(3 downto 0);
        and_out         : out    vl_logic;
        or_out          : out    vl_logic;
        not_out         : out    vl_logic;
        nand_out        : out    vl_logic;
        aoi_out         : out    vl_logic;
        xor_out_1       : out    vl_logic;
        xor_out_2       : out    vl_logic
    );
end Ex1;
