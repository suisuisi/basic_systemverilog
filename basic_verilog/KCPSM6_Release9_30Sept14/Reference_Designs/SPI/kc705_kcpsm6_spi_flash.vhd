--
-------------------------------------------------------------------------------------------
-- Copyright � 2011-2013, Xilinx, Inc.
-- This file contains confidential and proprietary information of Xilinx, Inc. and is
-- protected under U.S. and international copyright and other intellectual property laws.
-------------------------------------------------------------------------------------------
--
-- Disclaimer:
-- This disclaimer is not a license and does not grant any rights to the materials
-- distributed herewith. Except as otherwise provided in a valid license issued to
-- you by Xilinx, and to the maximum extent permitted by applicable law: (1) THESE
-- MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY
-- DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY,
-- INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT,
-- OR FITNESS FOR ANY PARTICULAR PURPOSE; and (2) Xilinx shall not be liable
-- (whether in contract or tort, including negligence, or under any other theory
-- of liability) for any loss or damage of any kind or nature related to, arising
-- under or in connection with these materials, including for any direct, or any
-- indirect, special, incidental, or consequential loss or damage (including loss
-- of data, profits, goodwill, or any type of loss or damage suffered as a result
-- of any action brought by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the possibility of the same.
--
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-safe, or for use in any
-- application requiring fail-safe performance, such as life-support or safety
-- devices or systems, Class III medical devices, nuclear facilities, applications
-- related to the deployment of airbags, or any other applications that could lead
-- to death, personal injury, or severe property or environmental damage
-- (individually and collectively, "Critical Applications"). Customer assumes the
-- sole risk and liability of any use of Xilinx products in Critical Applications,
-- subject only to applicable laws and regulations governing limitations on product
-- liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES.
--
-------------------------------------------------------------------------------------------
--
-- �            _� ______ ____� ____� __� __� __��
--             | |/ / ___|� _ \/ ___||� \/� |/ /_�
--             | ' / |�� | |_) \___ \| |\/| | '_ \
--             | . \ |___|� __/ ___) | |� | | (_) )
--             |_|\_\____|_|�� |____/|_|� |_|\___/
-- ������������������������������������
-- 
-- 
-- KCPSM6 reference design on Xilinx KC705 Evaluation Board (www.xilinx.com).
-- 
-- XC7K325T-1FFG900 Device  
--
-- Ken Chapman - Xilinx Ltd.
--
-- 21st September 2012 - Initial version
--    9th October 2012 - Corrections to comments
--     18th March 2013 - Alterations to names of modules.
--
--
-- The primary purpose of this reference design is to illustrate how KCPSM6 can implement 
-- the signaling and protocol required to communicate and control an SPI Flash memory 
-- that was initially connected to the device to facilitate device configuration. 
--
-- The design is based on the standard reference designs provided with KCPSM6 (PicoBlaze).
-- These provide a UART-USB connection allowing messages to be displayed on a terminal and 
-- for keyboard entries to allow a degree of control and data input. Please refer to the 
-- documentation provided with KCPSM6 and the UART macros if you need to know more about 
-- PicoBlaze and UART communication. PicoTerm is also supplied with KCPSM6 and ideally 
-- suited to this application so please use it.
--
-- In this example the aim is to communicate with the Micron/Numonyx N25Q128 device on the 
-- KC705 board. There will be some items specific to this device and board but it is hoped 
-- that this design can be a reference starting point for other arrangements. The design 
-- implements a classic 4-wire interface and serial communication. Most of the work is 
-- perfomed by KCPSM6 which is defined and described in the PSM code provided. However, the
-- starting point is to set up those four connections.
--  
-- The SPI Flash memory is initially connected to the device to facilitate configuration so 
-- this leads to a very precise set of pins being used. Obviously this design must use those 
-- same pins but whilst three of those pins become regular I/O after configuration the CCLK
-- can only be accessed via the STARTUPE2 primitive so that is a critical part of this design 
-- to look out for.
--
-- The SPI interface is formed of the signals listed below...  
--
--  spi_clk    Clock from FPGA to SPI Flash         Pin B10 (CCLK) accessed via STARTUPE2
--  spi_cs_b   Chip Select from FPGA to SPI Flash   Pin U19 (FCS_B)
--  spi_mosi   Data from FPGA to SPI Flash          Pin P24 (D00)
--  spi_miso   Data from SPI Flash to FPGA          Pin R25 (D01/DIN)
--
--
--   IMPORTANT: The KC705 board requirs the 'M0' switch on SW13 to be set to '1' so that 
--              the 'spi_cs_b' signal is routed through to the SPI Flash rather than the 
--              alternative parallel Flash. For Master SPI configuration the required mode 
--              switch setting is M[2:0] = "001"  so when the SPI Flash is used to 
--              configure the device as well the M0 switch will already be High.
-- 
--
-------------------------------------------------------------------------------------------
--
-- Library declarations
--
-- Standard IEEE libraries
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--
-- The Unisim Library is used to define Xilinx primitives. It is also used during
-- simulation. The source can be viewed at %XILINX%\vhdl\src\unisims\unisim_VCOMP.vhd
-- 
library unisim;
use unisim.vcomponents.all;
--
--
-------------------------------------------------------------------------------------------
--
--

entity kc705_kcpsm6_spi_flash is
  Port (  uart_rx : in std_logic;
          uart_tx : out std_logic;
         spi_cs_b : out std_logic := '1';
         spi_mosi : out std_logic := '0';
         spi_miso : in std_logic;
          cpu_rst : in std_logic;
         clk200_p : in std_logic;
         clk200_n : in std_logic);
  end kc705_kcpsm6_spi_flash;

--
-------------------------------------------------------------------------------------------
--
-- Start of test architecture
--
architecture Behavioral of kc705_kcpsm6_spi_flash is
--
-------------------------------------------------------------------------------------------
--
-- Components
--
-------------------------------------------------------------------------------------------
--

--
-- declaration of KCPSM6
--

  component kcpsm6 
    generic(                 hwbuild : std_logic_vector(7 downto 0) := X"00";
                    interrupt_vector : std_logic_vector(11 downto 0) := X"3FF";
             scratch_pad_memory_size : integer := 64);
    port (                   address : out std_logic_vector(11 downto 0);
                         instruction : in std_logic_vector(17 downto 0);
                         bram_enable : out std_logic;
                             in_port : in std_logic_vector(7 downto 0);
                            out_port : out std_logic_vector(7 downto 0);
                             port_id : out std_logic_vector(7 downto 0);
                        write_strobe : out std_logic;
                      k_write_strobe : out std_logic;
                         read_strobe : out std_logic;
                           interrupt : in std_logic;
                       interrupt_ack : out std_logic;
                               sleep : in std_logic;
                               reset : in std_logic;
                                 clk : in std_logic);
  end component;


--
-- Development Program Memory
--

  component n25q128_spi_uart_bridge
    generic(             C_FAMILY : string := "S6"; 
                C_RAM_SIZE_KWORDS : integer := 1;
             C_JTAG_LOADER_ENABLE : integer := 0);
    Port (      address : in std_logic_vector(11 downto 0);
            instruction : out std_logic_vector(17 downto 0);
                 enable : in std_logic;
                    rdl : out std_logic;                    
                    clk : in std_logic);
  end component;

--
-- UART Transmitter with integral 16 byte FIFO buffer
--

  component uart_tx6 
    Port (             data_in : in std_logic_vector(7 downto 0);
                  en_16_x_baud : in std_logic;
                    serial_out : out std_logic;
                  buffer_write : in std_logic;
           buffer_data_present : out std_logic;
              buffer_half_full : out std_logic;
                   buffer_full : out std_logic;
                  buffer_reset : in std_logic;
                           clk : in std_logic);
  end component;

--
-- UART Receiver with integral 16 byte FIFO buffer
--

  component uart_rx6 
    Port (           serial_in : in std_logic;
                  en_16_x_baud : in std_logic;
                      data_out : out std_logic_vector(7 downto 0);
                   buffer_read : in std_logic;
           buffer_data_present : out std_logic;
              buffer_half_full : out std_logic;
                   buffer_full : out std_logic;
                  buffer_reset : in std_logic;
                           clk : in std_logic);
  end component;

--
--
-------------------------------------------------------------------------------------------
--
-- Signals
--
-------------------------------------------------------------------------------------------
--
--
--
-- Signals to create and distribute a 100MHz clock from the 200MHz differential input
--
signal         clock_divide : std_logic := '0';
signal               clk200 : std_logic;
signal                  clk : std_logic;
--
--
-- Signals used to connect KCPSM6
--
signal              address : std_logic_vector(11 downto 0);
signal          instruction : std_logic_vector(17 downto 0);
signal          bram_enable : std_logic;
signal              in_port : std_logic_vector(7 downto 0);
signal             out_port : std_logic_vector(7 downto 0);
signal              port_id : std_logic_vector(7 downto 0);
signal         write_strobe : std_logic;
signal       k_write_strobe : std_logic;
signal          read_strobe : std_logic;
signal            interrupt : std_logic;
signal        interrupt_ack : std_logic;
signal         kcpsm6_sleep : std_logic;
signal         kcpsm6_reset : std_logic;
signal                  rdl : std_logic;
--
-- Signals used to connect UART_TX6
--
signal      uart_tx_data_in : std_logic_vector(7 downto 0);
signal     write_to_uart_tx : std_logic;
signal uart_tx_data_present : std_logic;
signal    uart_tx_half_full : std_logic;
signal         uart_tx_full : std_logic;
signal        uart_tx_reset : std_logic;
--
-- Signals used to connect UART_RX6
--
signal     uart_rx_data_out : std_logic_vector(7 downto 0);
signal    read_from_uart_rx : std_logic;
signal uart_rx_data_present : std_logic;
signal    uart_rx_half_full : std_logic;
signal         uart_rx_full : std_logic;
signal        uart_rx_reset : std_logic;
--
-- Signals used to define baud rate
--
signal           baud_count : integer range 0 to 53 := 0; 
signal         en_16_x_baud : std_logic := '0';
--
--
-- Signals for communication with SPI Flash Memory
--
--   An internal signal is required for 'spi_clk' but 'spi_cs_b', 'spi_mosi' and 
--   'spi_miso' are all direct pin connections
--
signal              spi_clk : std_logic := '0';
--
--
-------------------------------------------------------------------------------------------
--
-- Start of circuit description
--
-------------------------------------------------------------------------------------------
--
begin

  --
  -----------------------------------------------------------------------------------------
  -- Create 100MHz clock from 200MHz differential input
  -----------------------------------------------------------------------------------------
  --
  -- A simple toggle flip-flop arrangement is used to divide the clock as no phase 
  -- relationship with the original 200MHz clock is required in this application.
  -- 

  --
  -- 200MHz differential input clock
  --
 
  clk200_input_buffer: IBUFGDS
    port map (  I => clk200_p,
               IB => clk200_n,
                O => clk200);


  clock_generation: process(clk200)
  begin
    if clk200'event and clk200 = '1' then
      clock_divide <= not(clock_divide);
    end if;
  end process clock_generation;


  --
  -- BUFG to distribute 100MHz clock 
  --

  clock_100mhz_buffer: BUFG
    port map (   I => clock_divide,
                 O => clk);

  --
  -----------------------------------------------------------------------------------------
  -- Instantiate KCPSM6 and connect to program ROM
  -----------------------------------------------------------------------------------------
  --
  -- The generics can be defined as required. In this case the 'hwbuild' value is used to 
  -- define a version using the ASCII code for the desired letter and the interrupt vector
  -- has been set to 7F0 to provide 16 instructions for an Interrupt Service Routine (ISR)
  -- before reaching the end of a 2K memory. 
  -- 
  --

  processor: kcpsm6
    generic map (                 hwbuild => X"42",    -- 42 hex is ASCII character "B"
                         interrupt_vector => X"7F0",   
                  scratch_pad_memory_size => 256)
    port map(      address => address,
               instruction => instruction,
               bram_enable => bram_enable,
                   port_id => port_id,
              write_strobe => write_strobe,
            k_write_strobe => k_write_strobe,
                  out_port => out_port,
               read_strobe => read_strobe,
                   in_port => in_port,
                 interrupt => interrupt,
             interrupt_ack => interrupt_ack,
                     sleep => kcpsm6_sleep,
                     reset => kcpsm6_reset,
                       clk => clk);
 

  --
  -- Reset by press button (active Low) or JTAG Loader enabled Program Memory 
  --

  kcpsm6_reset <= rdl or cpu_rst;


  --
  -- Unused signals tied off until required.
  -- Tying to other signals used to minimise warning messages.
  --

  kcpsm6_sleep <= write_strobe and k_write_strobe;  -- Always '0'
  interrupt <= interrupt_ack;

  --
  -- Development Program Memory 
  --   JTAG Loader enabled for rapid code development. 
  --

  program_rom: n25q128_spi_uart_bridge
    generic map(             C_FAMILY => "7S", 
                    C_RAM_SIZE_KWORDS => 2,
                 C_JTAG_LOADER_ENABLE => 1)
    port map(      address => address,      
               instruction => instruction,
                    enable => bram_enable,
                       rdl => rdl,
                       clk => clk);


  --
  -----------------------------------------------------------------------------------------
  -- SPI Flash Memory interface  
  -----------------------------------------------------------------------------------------
  --
  -- The KC705 board has a 128Mbit SPI Flash connected to the appropriate pins necessary 
  -- for device configuration. The memory is an Micron/Numonyx N25Q128 device.
  --
  -- To access this SPI Flash device after configuration three of the configuration pins
  -- become regular I/O but the clock must reuse CCLK and that is only accessible via the 
  -- STARTUPE2 primitive defined here.
  -- 
  -- The SPI interface is formed of 4 signals which are 'bit-banged' by KCPSM6 to
  -- implement all operations.
  --                                                  Pins on XC7K325T-1FFG900  
  --  spi_clk    Clock from FPGA to SPI Flash         Pin B10 (CCLK) accessed via STARTUPE2
  --  spi_cs_b   Chip Select from FPGA to SPI Flash   Pin U19 (FCS_B)
  --  spi_mosi   Data from FPGA to SPI Flash          Pin P24 (D00)
  --  spi_miso   Data from SPI Flash to FPGA          Pin R25 (D01/DIN)
  --

  spi_connect: STARTUPE2
    generic map(      PROG_USR => "FALSE", 
                 SIM_CCLK_FREQ => 0.0)
    port map (    CFGCLK => open,
                 CFGMCLK => open,
                     EOS => open,
                    PREQ => open,
                     CLK => '0',
                     GSR => '0',
                     GTS => '0',
               KEYCLEARB => '0',
                    PACK => '0',
                USRCCLKO => spi_clk,   -- Provide signal to output on CCLK pin 
               USRCCLKTS => '0',       -- Enable CCLK pin  
                USRDONEO => '1',       -- Drive DONE pin High even though tri-state
               USRDONETS => '1' );     -- Maintain tri-state of DONE pin 

  --
  -----------------------------------------------------------------------------------------
  -- UART Transmitter with integral 16 byte FIFO buffer
  -----------------------------------------------------------------------------------------
  --
  -- Write to buffer in UART Transmitter at port address 01 hex
  -- 

  tx: uart_tx6 
  port map (              data_in => uart_tx_data_in,
                     en_16_x_baud => en_16_x_baud,
                       serial_out => uart_tx,
                     buffer_write => write_to_uart_tx,
              buffer_data_present => uart_tx_data_present,
                 buffer_half_full => uart_tx_half_full,
                      buffer_full => uart_tx_full,
                     buffer_reset => uart_tx_reset,              
                              clk => clk);


  --
  -----------------------------------------------------------------------------------------
  -- UART Receiver with integral 16 byte FIFO buffer
  -----------------------------------------------------------------------------------------
  --
  -- Read from buffer in UART Receiver at port address 01 hex.
  --
  -- When KCPMS6 reads data from the receiver a pulse must be generated so that the 
  -- FIFO buffer presents the next character to be read and updates the buffer flags.
  -- 
  
  rx: uart_rx6 
  port map (            serial_in => uart_rx,
                     en_16_x_baud => en_16_x_baud,
                         data_out => uart_rx_data_out,
                      buffer_read => read_from_uart_rx,
              buffer_data_present => uart_rx_data_present,
                 buffer_half_full => uart_rx_half_full,
                      buffer_full => uart_rx_full,
                     buffer_reset => uart_rx_reset,              
                              clk => clk);

  --
  -----------------------------------------------------------------------------------------
  -- RS232 (UART) baud rate 
  -----------------------------------------------------------------------------------------
  --
  -- To set serial communication baud rate to 115,200 then en_16_x_baud must pulse 
  -- High at 1,843,200Hz which is every 54.28 cycles at 100MHz. In this implementation 
  -- a pulse is generated every 54 cycles resulting is a baud rate of 115,741 baud which
  -- is only 0.5% high and well within limits.
  --

  baud_rate: process(clk)
  begin
    if clk'event and clk = '1' then
      if baud_count = 53 then                    -- counts 54 states including zero
        baud_count <= 0;
        en_16_x_baud <= '1';                     -- single cycle enable pulse
       else
        baud_count <= baud_count + 1;
        en_16_x_baud <= '0';
      end if;
    end if;
  end process baud_rate;

  --
  -----------------------------------------------------------------------------------------
  -- General Purpose Input Ports. 
  -----------------------------------------------------------------------------------------
  --
  -- Two input ports are used with the UART macros. The first is used to monitor the flags
  -- on both the UART transmitter and receiver. The second is used to read the data from 
  -- the UART receiver. Note that the read also requires a 'buffer_read' pulse to be 
  -- generated.
  --
  -- This design includes a third input port to read 8 general purpose switches.
  --

  input_ports: process(clk)
  begin
    if clk'event and clk = '1' then
      case port_id(1 downto 0) is

        -- Read UART status at port address 00 hex
        when "00" =>  in_port(0) <= uart_tx_data_present;
                      in_port(1) <= uart_tx_half_full;
                      in_port(2) <= uart_tx_full; 
                      in_port(3) <= uart_rx_data_present;
                      in_port(4) <= uart_rx_half_full;
                      in_port(5) <= uart_rx_full;

        -- Read UART_RX6 data at port address 01 hex
        -- (see 'buffer_read' pulse generation below) 
        when "01" =>       in_port <= uart_rx_data_out;
 

        -- Unused port address 02 hex
        -- when "10" =>       in_port <= ????;

        -- Read SPI serial data MISO at address 03 hex
        -- Bit7 used to help with MSB first nature of SPI communication

        when "11" =>    in_port <= spi_miso & "0000000";  


        -- Don't Care for unsued case(s) ensures minimum logic implementation  

        when others =>    in_port <= "XXXXXXXX";  

      end case;

      -- Generate 'buffer_read' pulse following read from port address 01

      if (read_strobe = '1') and (port_id(1 downto 0) = "01") then
        read_from_uart_rx <= '1';
       else
        read_from_uart_rx <= '0';
      end if;
 
    end if;
  end process input_ports;


  --
  -----------------------------------------------------------------------------------------
  -- General Purpose Output Ports 
  -----------------------------------------------------------------------------------------
  --
  -- In this design there are two output ports. 
  --   A simple output port used to output signals to the SPI Flash.
  --   A port used to write data directly to the FIFO buffer within 'uart_tx6' macro.
  --

  output_ports: process(clk)
  begin
    if clk'event and clk = '1' then
      -- 'write_strobe' is used to qualify all writes to general output ports.
      if write_strobe = '1' then

        -- Signals to SPI Flash Memory at address 04 hex.
        -- Bit7 used for MOSI to help with MSB first nature of SPI communication

        if port_id(2) = '1' then
          spi_clk <= out_port(0);
          spi_cs_b <= out_port(1);
          spi_mosi <= out_port(7);
        end if;

      end if;
    end if; 
  end process output_ports;


  --
  -- Write directly to the FIFO buffer within 'uart_tx6' macro at port address 01 hex.
  -- Note the direct connection of 'out_port' to the UART transmitter macro and the 
  -- way that a single clock cycle write pulse is generated to capture the data.
  -- 

  uart_tx_data_in <= out_port;

  write_to_uart_tx  <= '1' when (write_strobe = '1') and (port_id(0) = '1')
                           else '0';                     

  --
  -----------------------------------------------------------------------------------------
  -- Constant-Optimised Output Ports 
  -----------------------------------------------------------------------------------------
  --
  -- One constant-optimised output port is used to facilitate resetting of the UART macros.
  --

  constant_output_ports: process(clk)
  begin
    if clk'event and clk = '1' then
      if k_write_strobe = '1' then

        if port_id(0) = '1' then
          uart_tx_reset <= out_port(0);
          uart_rx_reset <= out_port(1);
        end if;

      end if;
    end if; 
  end process constant_output_ports;

  --
  -----------------------------------------------------------------------------------------
  --

end Behavioral;

-------------------------------------------------------------------------------------------
--
-- END OF FILE kc705_kcpsm6_spi_flash.vhd
--
-------------------------------------------------------------------------------------------

