--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

package ESPIDF.Sockets is

   type Socket_Domain is new int with Convention => C;

   function AF_UNSPEC return Socket_Domain is (0);
   function AF_INET   return Socket_Domain is (2);
   function AF_INET6  return Socket_Domain is (10);

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

   type Socket_Descriptor is new int with Convention => C;

   function socket
     (Socket_Domain   : ESPIDF.Sockets.Socket_Domain;
      Socket_Type     : ESPIDF.Sockets.Socket_Type;
      Socket_Protocol : ESPIDF.Sockets.Socket_Protocol)
      return Socket_Descriptor
     with Import, Convention => C, External_Name => "lwip_socket";

end ESPIDF.Sockets;