library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.constants.all;

entity SUM_GENERATOR is
  generic(NBIT: natural:= numBitP4;
          NBLKS: natural:= numBlocksP4);
  port(A,B: in std_logic_vector((NBIT*NBLKS)-1 downto 0);
       Cin: in std_logic_vector(NBLKS-1 downto 0);
       Sum: out std_logic_vector((NBIT*NBLKS)-1 downto 0));
end SUM_GENERATOR;

architecture STRUCTURAL of SUM_GENERATOR is
  component CSB is
    generic(NBIT: natural := numBitP4);
    port(A,B: in std_logic_vector(NBIT-1 downto 0);
         Cin: in std_logic;
       --Cout: out std_logic;
       -- The carry-out is not useful since the carries
       -- are generated by an external logic
         Sum: out std_logic_vector(NBIT-1 downto 0));
  end component;

begin

  SG: for i in 0 to NBLKS-1 generate
    CSB1: CSB generic map (NBIT => NBIT)
      port map (A=>A(((i+1)*NBIT)-1 downto i*NBIT), B=>B(((i+1)*NBIT)-1 downto i*NBIT),
          Cin=>Cin(i), Sum=>Sum(((i+1)*NBIT)-1 downto i*NBIT));
  end generate;

end STRUCTURAL;

configuration CFG_SG_STRUCTURAL of SUM_GENERATOR is
  for STRUCTURAL
    for SG
      for all : CSB
        use configuration work.CFG_CSB_STRUCTURAL;
      end for;
    end for;
  end for;
end CFG_SG_STRUCTURAL;
