--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

package body ESPIDF.Sockets is

   ---------
   -- Set --
   ---------

   procedure Set
     (Self    : out sockaddr;
      Address : in_addr_t;
      Port    : in_port_t)
   is
      procedure Internal
        (Self    : out sockaddr;
         Address : in_addr_t;
         Port    : in_port_t)
        with Import, Convention => C, External_Name => "__ada_Set_sockaddr_ip";

   begin
      Internal (Self, Address, Port);
   end Set;

end ESPIDF.Sockets;