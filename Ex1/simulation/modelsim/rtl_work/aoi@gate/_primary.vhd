library verilog;
use verilog.vl_types.all;
entity aoiGate is
    port(
        \in\            : in     vl_logic_vector(3 downto 0);
        \out\           : out    vl_logic
    );
end aoiGate;
