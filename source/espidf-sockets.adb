--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

package body ESPIDF.Sockets is

   function lwip_recvfrom
     (socket  : Socket_Descriptor;
      buffer  : System.Address;
      length  : size_t;
      flags   : int;
      from    : access sockaddr;
      fromlen : access socklen_t) return ssize_t
     with Import, Convention => C, External_Name => "lwip_recvfrom";

   function lwip_sendto
     (socket : Socket_Descriptor;
      buffer : System.Address;
      length : size_t;
      flags  : int;
      to     : sockaddr;
      tolen  : socklen_t) return ssize_t
     with Import, Convention => C, External_Name => "lwip_sendto";

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

   --------------
   -- recvfrom --
   --------------

   function recvfrom
     (socket  : Socket_Descriptor;
      buffer  : System.Address;
      length  : size_t;
      flags   : int;
      from    : aliased out sockaddr) return ssize_t
   is
      fromlen : aliased socklen_t := socklen_t (sizeof_sockaddr_storage);

   begin
      return
        lwip_recvfrom
          (socket, buffer, length, flags, from'Access, fromlen'Access);
   end recvfrom;

   --------------
   -- recvfrom --
   --------------

   function recvfrom
     (socket  : Socket_Descriptor;
      buffer  : System.Address;
      length  : size_t;
      flags   : int) return ssize_t is
   begin
      return lwip_recvfrom (socket, buffer, length, flags, null, null);
   end recvfrom;

   ------------
   -- sendto --
   ------------

   function sendto
     (socket : Socket_Descriptor;
      buffer : System.Address;
      length : size_t;
      flags  : int;
      to     : sockaddr) return ssize_t is
   begin
      return
        lwip_sendto
          (socket,
           buffer,
           length,
           flags,
           to,
           socklen_t (sizeof_sockaddr_storage));
   end sendto;

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