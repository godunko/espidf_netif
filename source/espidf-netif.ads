--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

with ESPIDF.Event;

package ESPIDF.NETIF is

   type esp_netif_t is limited private;

   type esp_netif_t_ptr is access all esp_netif_t with Convention => C;

   IP_EVENT : constant ESPIDF.Event.esp_event_base_t
     with Import, Convention => C, External_Name => "IP_EVENT";

   IP_EVENT_STA_GOT_IP            : constant int32_t := 0;
   IP_EVENT_STA_LOST_IP           : constant int32_t := 1;
   IP_EVENT_ASSIGNED_IP_TO_CLIENT : constant int32_t := 2;
   IP_EVENT_GOT_IP6               : constant int32_t := 3;
   IP_EVENT_ETH_GOT_IP            : constant int32_t := 4;
   IP_EVENT_ETH_LOST_IP           : constant int32_t := 5;
   IP_EVENT_PPP_GOT_IP            : constant int32_t := 6;
   IP_EVENT_PPP_LOST_IP           : constant int32_t := 7;
   IP_EVENT_TX_RX                 : constant int32_t := 8;
   IP_EVENT_NETIF_UP              : constant int32_t := 9;
   IP_EVENT_NETIF_DOWN            : constant int32_t := 10;

   function esp_netif_init return esp_err_t
     with Import, Convention => C, External_Name => "esp_netif_init";

   procedure esp_netif_init;

private

   type esp_netif_t is limited null record with Convention => C;
   --  Full declaration of this type is not visible via "esp_netif.h"

end ESPIDF.NETIF;
