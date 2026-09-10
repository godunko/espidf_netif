--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

package body ESPIDF.Sockets is

   type socklen_t is new int with Convention => C;

   ----------
   -- bind --
   ----------

   function bind
     (Socket  : Socket_Descriptor;
      Address : sockaddr) return int
   is
      function Internal
        (sockfd  : Socket_Descriptor;
         addr    : sockaddr;
         addrlen : socklen_t) return int
        with Import, Convention => C, External_Name => "lwip_bind";

   begin
      return Internal (Socket, Address, socklen_t (sizeof_sockaddr_storage));
   end bind;

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