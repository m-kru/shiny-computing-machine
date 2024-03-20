library counters;
  use counters.counters.all;

entity tb_counter is
end entity;

architecture test of tb_counter is
begin

  test_init : process is
    constant MIN : integer := -7;
    constant MAX : integer := 8917;
    constant VAL : integer := 147;
    variable c : counter_t;
  begin
    c := init(MAX);
    assert c.min = 0;
    assert c.val = 0;
    assert c.max = MAX;
    c := init(MAX, VAL);
    assert c.min = 0;
    assert c.val = VAL;
    assert c.max = MAX;
    c := init(MAX, VAL, MIN);
    assert c.min = MIN;
    assert c.val = VAL;
    assert c.max = MAX;
    wait;
  end process;


  test_init_width : process is
    constant WIDTH : integer := 8;
    variable c : counter_t;
  begin
    c := init_width(WIDTH);
    assert c.min = 0;
    assert c.val = 0;
    assert c.max = 255;
    c := init_width(WIDTH, true);
    assert c.min = 0;
    assert c.val = 255;
    assert c.max = 255;
    wait;
  end process;


  test_equal_integer : process is
    constant MAX : integer := 1023;
    variable c : counter_t := init(MAX);
  begin
    assert c = 0;
    c := inc(c);
    assert c = 1;
    c := inc(c, 1000);
    assert c = 1001;
    wait;
  end process;


  test_inequal_integer : process is
    variable c : counter_t := init(10);
  begin
    assert c /= 1;
    c := inc(c);
    assert c /= 0;
    wait;
  end process;


  test_less_than_integer : process is
    variable c : counter_t := init(10);
  begin
    assert c < 1;
    c := inc(c);
    assert c < 2;
    wait;
  end process;


  test_less_than_equal_integer : process is
    variable c : counter_t := init(10);
  begin
    assert c <= 0;
    c := inc(c);
    assert c <= 2;
    wait;
  end process;


  test_greater_than_integer : process is
    variable c : counter_t := init(10);
  begin
    assert c > -1;
    c := inc(c);
    assert c > 0;
    wait;
  end process;


  test_greater_than_equal_integer : process is
    variable c : counter_t := init(10);
  begin
    assert c >= 0;
    c := inc(c);
    assert c >= 0;
    wait;
  end process;


  test_equal_counter : process is
    constant MAX1 : integer := 6;
    constant MAX2 : integer := 17;
    variable c1 : counter_t := init(MAX1);
    variable c2 : counter_t := init(MAX2);
  begin
    assert c1 = c2;
    c1 := inc(c1);
    c2 := inc(c2);
    assert c1 = c2;
    wait;
  end process;


  test_inequal_counter : process is
    variable c1 : counter_t := init(10);
    variable c2 : counter_t := init(20);
  begin
    c1 := inc(c1);
    assert c1 /= c2;
    wait;
  end process;


  test_less_than_counter : process is
    variable c1 : counter_t := init(10);
    variable c2 : counter_t := init(10);
  begin
    c2 := inc(c2);
    assert c1 < c2;
    wait;
  end process;


  test_less_than_equal_counter : process is
    variable c1 : counter_t := init(5);
    variable c2 : counter_t := init(5);
  begin
    assert c1 <= c2;
    c2 := inc(c2);
    assert c1 <= c2;
    wait;
  end process;


  test_greater_than_counter : process is
    variable c1 : counter_t := init(10);
    variable c2 : counter_t := init(10);
  begin
    c1 := inc(c1);
    assert c1 > c2;
    wait;
  end process;


  test_greater_than_equal_counter : process is
    variable c1 : counter_t := init(10);
    variable c2 : counter_t := init(10);
  begin
    assert c1 >= c2;
    c1 := inc(c1);
    assert c1 > c2;
    wait;
  end process;


  test_is_min : process is
    constant MAX : integer := 1023;
    constant VAL : integer := 1023;
    constant MIN : integer := 1023;
    variable c : counter_t := init(MAX, VAL, MIN);
  begin
    assert is_min(c);
    c := inc(c);
    assert is_min(c);
    wait;
  end process;


  test_is_max : process is
    constant MAX : integer := 1023;
    variable c : counter_t := init(MAX);
  begin
    assert not is_max(c);
    c := inc(c, MAX);
    assert is_max(c);
    wait;
  end process;


  test_inc : process is
    constant MAX : integer := 15;
    variable c : counter_t := init(MAX);
  begin
    c := inc(c);
    assert c = 1;
    c := inc(c, 4);
    assert c = 5;
    c := inc(c, 12);
    assert c = 1;
    c := inc(c, 32);
    assert c = 1;
    c := inc(c, 15);
    assert c = 0;
    wait;
  end process;


  test_inc_positive_max_negative_min : process is
    variable c : counter_t := init(15, 0, -16);
  begin
    c := inc(c);
    assert c = 1;
    c := inc(c, 4);
    assert c = 5;
    c := inc(c, 12);
    assert c = -15;
    c := inc(c, 1);
    assert c = -14;
    c := inc(c, 14);
    assert c = 0;
    wait;
  end process;


  test_inc_max_and_min_negative : process is
    variable c : counter_t := init(-10, -15, -20);
  begin
    c := inc(c);
    assert c = -14;
    c := inc(c, 4);
    assert c = -10;
    c := inc(c);
    assert c = -20;
    c := inc(c, 11);
    assert c = -20;
    wait;
  end process;


  test_inc_if : process is
    constant MAX : integer := 15;
    variable c : counter_t := init(MAX);
  begin
    c := inc_if(c, true, 3);
    assert c = 3;
    c := inc_if(c, false);
    assert c = 3;
    c := inc_if(c, false, 3);
    assert c = 3;
    wait;
  end process;


  test_rst_min : process is
    constant MAX : integer := 15;
    constant MIN : integer := 7;
    variable c : counter_t := init(MAX, MIN, MIN);
  begin
    assert is_min(c);
    c := inc(c);
    assert not is_min(c);
    c := rst_min(c);
    assert is_min(c);
    wait;
  end process;


  test_rst_min_if : process is
    constant MAX : integer := 15;
    constant MIN : integer := 7;
    variable c : counter_t := init(MAX, MAX, MIN);
  begin
    assert not is_min(c);
    c := rst_min_if(c, true);
    assert is_min(c);
    c := inc(c);
    assert not is_min(c);
    c := rst_min_if(c, true);
    assert is_min(c);
    wait;
  end process;


  test_rst_max : process is
    constant MAX : integer := 15;
    constant MIN : integer := 7;
    variable c : counter_t := init(MAX, MAX, MIN);
  begin
    assert is_max(c);
    c := inc(c);
    assert not is_max(c);
    c := rst_max(c);
    assert is_max(c);
    wait;
  end process;


  test_rst_max_if : process is
    constant MAX : integer := 15;
    constant MIN : integer := 7;
    variable c : counter_t := init(MAX, MIN, MIN);
  begin
    assert not is_max(c);
    c := rst_max_if(c, true);
    assert is_max(c);
    c := inc(c);
    assert not is_max(c);
    c := rst_max_if(c, true);
    assert is_max(c);
    wait;
  end process;

  test_set : process is
    constant MAX : integer := 15;
    constant MIN : integer := -15;
    variable c : counter_t := init(MAX, MIN, MIN);
  begin
    c := set(c, 0);
    assert c = 0;
    c := set(c, MIN);
    assert is_min(c);
    c := set(c, MAX);
    assert is_max(c);
    c := set(c, 3);
    assert c = 3;
    wait;
  end process;


  test_set_if : process is
    variable c : counter_t := init(8);
  begin
    c := set_if(c, 5, false);
    assert c = 0;
    c := set_if(c, 5, true);
    assert c = 5;
    c := set_if(c, 8, true);
    assert c = 8;
    wait;
  end process;


  test_to_strig : process is
    variable c1 : counter_t := init(255);
    variable c2 : counter_t := init(1023, 151, -127);
  begin
    report to_string(c1);
    report to_string(c2);
    wait;
  end process;

end architecture;
