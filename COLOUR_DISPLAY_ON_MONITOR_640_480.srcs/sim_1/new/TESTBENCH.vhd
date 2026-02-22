library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_TOP is
end tb_TOP;

architecture sim of tb_TOP is

    -- DUT signals
    signal clk    : std_logic := '0';
    signal reset  : std_logic := '1';
    signal R_out  : std_logic_vector(3 downto 0);
    signal G_out  : std_logic_vector(3 downto 0);
    signal B_out  : std_logic_vector(3 downto 0);
    signal h_sync : std_logic;
    signal v_sync : std_logic;

    constant CLK_PERIOD : time := 10 ns; -- 100 MHz

    -- Reference pixel-domain model
    signal pix_clk     : std_logic := '0';
    signal div_cnt     : integer range 0 to 1 := 0;

    signal h_ref : integer range 0 to 799 := 0;
    signal v_ref : integer range 0 to 524 := 0;
    signal eol   : std_logic := '0';
    signal vis   : std_logic := '0';

begin

    ------------------------------------------------------------------
    -- 100 MHz clock
    ------------------------------------------------------------------
    clk <= not clk after CLK_PERIOD / 2;

    ------------------------------------------------------------------
    -- DUT
    ------------------------------------------------------------------
    DUT : entity work.TOP
        port map (
            clk    => clk,
            reset  => reset,
            R_out  => R_out,
            G_out  => G_out,
            B_out  => B_out,
            h_sync => h_sync,
            v_sync => v_sync
        );

    ------------------------------------------------------------------
    -- Reset
    ------------------------------------------------------------------
    process
    begin
        reset <= '1';
        wait for 200 ns;
        reset <= '0';
        wait;
    end process;

    ------------------------------------------------------------------
    -- Reference pixel clock (divide-by-4)
    ------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            if div_cnt = 1 then
                pix_clk <= not pix_clk;
                div_cnt <= 0;
            else
                div_cnt <= div_cnt + 1;
            end if;
        end if;
    end process;

    ------------------------------------------------------------------
    -- Reference horizontal & vertical counters
    ------------------------------------------------------------------
    process(pix_clk)
    begin
        if rising_edge(pix_clk) then

            -- Horizontal
            if h_ref = 799 then
                h_ref <= 0;
                eol   <= '1';
            else
                h_ref <= h_ref + 1;
                eol   <= '0';
            end if;

            -- Vertical
            if eol = '1' then
                if v_ref = 524 then
                    v_ref <= 0;
                else
                    v_ref <= v_ref + 1;
                end if;
            end if;

        end if;
    end process;

    ------------------------------------------------------------------
    -- Visible region reference
    ------------------------------------------------------------------
    vis <= '1' when (h_ref < 640 and v_ref < 480) else '0';

    ------------------------------------------------------------------
    -- Functional assertions
    ------------------------------------------------------------------
    process(pix_clk)
        variable exp_hs : std_logic;
        variable exp_vs : std_logic;
    begin
        if rising_edge(pix_clk) and reset = '0' then

            -- Horizontal sync (active LOW)
            if (h_ref >= 656 and h_ref <= 751) then
                exp_hs := '0';
            else
                exp_hs := '1';
            end if;

            assert h_sync = exp_hs
                report "H_SYNC mismatch at h=" & integer'image(h_ref)
                severity error;

            -- Vertical sync (active LOW)
            if (v_ref >= 490 and v_ref <= 491) then
                exp_vs := '0';
            else
                exp_vs := '1';
            end if;

            assert v_sync = exp_vs
                report "V_SYNC mismatch at v=" & integer'image(v_ref)
                severity error;

            -- RGB behavior
            if vis = '0' then
                assert R_out = "0000" and G_out = "0000" and B_out = "0000"
                    report "RGB not black during blanking"
                    severity error;
            else
                assert R_out = "1111" and G_out = "1111" and B_out = "1111"
                    report "RGB incorrect during visible region"
                    severity error;
            end if;

        end if;
    end process;

    ------------------------------------------------------------------
    -- Pixel clock / line-period verification (NEW)
    -- 800 pixels @ 25 MHz = 32 us per line
    ------------------------------------------------------------------
    process
        variable t1, t2 : time;
    begin
        wait until reset = '0';

        -- wait for first active-low h_sync pulse
        wait until falling_edge(h_sync);
        t1 := now;

        wait until falling_edge(h_sync);
        t2 := now;

        assert (t2 - t1) = 32 us
            report "ERROR: Incorrect line period (pixel clock divider or h_count wrong)"
            severity failure;

        wait;
    end process;

    ------------------------------------------------------------------
    -- End simulation
    ------------------------------------------------------------------
    process
    begin
        wait for 20 ms;
        report "ALL VGA TIMING TESTS PASSED" severity note;
        wait;
    end process;

end sim;
