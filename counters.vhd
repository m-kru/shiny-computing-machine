-- SPDX-License-Identifier: MIT
-- https://github.com/m-kru/vhdl-counters
-- Copyright (c) 2023 Michał Kruszewski

package counters is

   -- Counter_t is a classic wrap around counter.
   -- This is a type of counter that is used most often.
   -- Its range is limited by the range of the integer type.
   type counter_t is record
      min : integer;
      max : integer;
      val : integer;
   end record;

   function init(max : integer; init_val : integer := 0; min : integer := 0) return counter_t;
   -- Init_width initializes a counter based on its width assuming the min value of the counter is 0.
   -- Max determines whether the init value shall equal max (max = true) or min (max = false).
   function init_width(width : positive; max : boolean := false) return counter_t;
   -- Equal returns true if counter c value equals x.
   function equal(c : counter_t; x : integer) return boolean;
   -- Is_zero returns true if counter c equals 0.
   -- It fails if zero is not in the range of the counter.
   function is_zero(c : counter_t) return boolean;
   -- Is_min returns true if counter c equals its min value.
   function is_min(c : counter_t) return boolean;
   -- Is_max returns true if counter c equals its max value.
   function is_max(c : counter_t) return boolean;
   -- Inc returns counter c incremented by i.
   function inc(c : counter_t; i : natural := 1) return counter_t;
   -- Inc_if returns counter c incremented by i, if the condition cond is met.
   -- Otherwise it returns counter c.
   function inc_if(c : counter_t; cond : boolean; i : natural := 1) return counter_t;
   -- Rst_min returns counter c reset to its min value.
   function rst_min(c : counter_t) return counter_t;
   -- Rst_min_if returns counter c reset to its min value if the condition cond is met.
   -- Otherwise it returns counter c.
   function rst_min_if(c : counter_t; cond : boolean) return counter_t;
   -- Rst_max returns counter c reset to its max value.
   function rst_max(c : counter_t) return counter_t;
   -- Rst_max_if returns counter c reset to its max value if the condition cond is met.
   -- Otherwise it returns counter c.
   function rst_max_if(c : counter_t; cond : boolean) return counter_t;
   -- Set returns counter c with value set to x.
   -- It fails if x value is not in range.
   function set(c : counter_t; x : integer) return counter_t;
   -- To_string converts counter c to string.
   function to_string(c : counter_t) return string;

end package;

package body counters is

   function init(max : integer; init_val : integer := 0; min : integer := 0) return counter_t is
      variable c : counter_t;
   begin
      if max < min then
         report "max value " & integer'image(max) & " is less than min value " & integer'image(min)
            severity failure;
      end if;
      if init_val < min then
         report "init value " & integer'image(init_val) & " is less than min value " & integer'image(min)
            severity failure;
      end if;
      if init_val > max then
         report "init value " & integer'image(init_val) & " is greater than max value " & integer'image(max)
            severity failure;
      end if;
      c.min := min;
      c.max := max;
      c.val := init_val;
      return c;
   end function;

   function init_width(width : positive; max : boolean := false) return counter_t is
      variable c : counter_t;
   begin
      c.max := 2 ** width - 1;
      c.min := 0;
      if max = false then
         c.val := 0;
      else
         c.val := c.max;
      end if;
      return c;
   end function;

   function equal(c : counter_t; x : integer) return boolean is
   begin
      if c.val = x then return true; end if;
      return false;
   end function;

   function is_zero(c : counter_t) return boolean is
   begin
      if 0 < c.min or 0 > c.max then
         report "0 is not within counter range <" & integer'image(c.min) & ";" & integer'image(c.max) & ">"
            severity failure;
      end if;
      if c.val = 0 then
         return true;
      end if;
      return false;
   end function;

   function is_min(c : counter_t) return boolean is
   begin
      if c.val = c.min then
         return true;
      end if;
      return false;
   end function;

   function is_max(c : counter_t) return boolean is
   begin
      if c.val = c.max then
         return true;
      end if;
      return false;
   end function;

   function inc(c : counter_t; i : natural := 1) return counter_t is
      variable r : counter_t := c;
      variable rang : positive := r.max - r.min + 1;
   begin
      r.val := (r.val + (i mod rang)) mod rang;
      return r;
   end function;

   function inc_if(c : counter_t; cond : boolean; i : natural := 1) return counter_t is
   begin
      if cond then
         return inc(c, i);
      end if;
      return c;
   end function;

   function rst_min(c : counter_t) return counter_t is
      variable r : counter_t := c;
   begin
      r.val := r.min;
      return r;
   end function;

   function rst_min_if(c : counter_t; cond : boolean) return counter_t is
   begin
      if cond then
         return rst_min(c);
      end if;
      return c;
   end function;

   function rst_max(c : counter_t) return counter_t is
      variable r : counter_t := c;
   begin
      r.val := r.max;
      return r;
   end function;

   function rst_max_if(c : counter_t; cond : boolean) return counter_t is
   begin
      if cond then
         return rst_max(c);
      end if;
      return c;
   end function;

   function set(c : counter_t; x : integer) return counter_t is
      variable r : counter_t := c;
   begin
      if x < r.min or r.max < x then
         report "value " & integer'image(x) & " is not within counter range <" & integer'image(c.min) & ";" & integer'image(c.max) & ">"
            severity failure;
      end if;
      r.val := x;
      return r;
   end function;

   function to_string(c : counter_t) return string is
   begin
      return "(val => " & integer'image(c.val) &", min => " & integer'image(c.min) & ", max => " & integer'image(c.max) & ")";
   end function;

end package body;
