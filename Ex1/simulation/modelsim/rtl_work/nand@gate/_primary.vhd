library verilog;
use verilog.vl_types.all;
entity nandGate is
    port(
        \in\            : in     vl_logic_vector(1 downto 0);
        \out\           : out    vl_logic
    );
end nandGate;
