--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

pragma Ada_2022;

private with System.Storage_Elements;

package ESPIDF.Sockets is

   type Address_Family is new int with Convention => C;

   function AF_UNSPEC return Address_Family is (0);
   function AF_INET   return Address_Family is (2);
   function AF_INET6  return Address_Family is (10);

   type Socket_Type is new int with Convention => C;

   function SOCK_STREAM return Socket_Type is (1);
   function SOCK_DGRAM  return Socket_Type is (2);
   function SOCK_RAW    return Socket_Type is (3);

   type Socket_Protocol is new int with Convention => C;

   function IPPROTO_IP      return Socket_Protocol is (0);
   function IPPROTO_ICMP    return Socket_Protocol is (1);
   function IPPROTO_TCP     return Socket_Protocol is (6);
   function IPPROTO_UDP     return Socket_Protocol is (17);
   function IPPROTO_IPV6    return Socket_Protocol is (41);
   function IPPROTO_ICMPV6  return Socket_Protocol is (58);
   function IPPROTO_UDPLITE return Socket_Protocol is (136);
   function IPPROTO_RAW     return Socket_Protocol is (255);

   type in_addr_t is new Interfaces.Unsigned_32 with Convention => C;
   type in_port_t is new Interfaces.Unsigned_16 with Convention => C;

   type sockaddr is limited private;

   procedure Set
     (Self    : out sockaddr;
      Address : in_addr_t;
      Port    : in_port_t);
   --  Configure `Self` to be used for AF_INET address family with the
   --  specified address and port.

   type Socket_Descriptor is new int with Convention => C;

   function socket
     (Socket_Domain   : ESPIDF.Sockets.Address_Family;
      Socket_Type     : ESPIDF.Sockets.Socket_Type;
      Socket_Protocol : ESPIDF.Sockets.Socket_Protocol)
      return Socket_Descriptor
     with Import, Convention => C, External_Name => "lwip_socket";

private

   sizeof_sockaddr_storage : constant int
      with Import, Convention => C,
           Link_Name => "__ada_sizeof_sockaddr_storage";

   type sockaddr_storage_Storage is
     new System.Storage_Elements.Storage_Array
       (1 .. System.Storage_Elements.Storage_Count
               (sizeof_sockaddr_storage)) with Convention => C;

   type sockaddr is limited record
      Storage : sockaddr_storage_Storage := (others => 0);
   end record;

end ESPIDF.Sockets;