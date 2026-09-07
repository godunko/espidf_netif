--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

with System;

with A0B.Types.Big_Endian;

with ESPIDF.C_Strings;
with ESPIDF.Event;

package ESPIDF.NETIF is

   type esp_netif_t is limited private;

   type esp_netif_t_ptr is access all esp_netif_t with Convention => C;

   type esp_netif_dhcp_option_mode_t is
     (ESP_NETIF_OP_START,
      ESP_NETIF_OP_SET,
      ESP_NETIF_OP_GET) with Convention => C;

   type esp_netif_dhcp_option_id_t is
     (ESP_NETIF_SUBNET_MASK,
      ESP_NETIF_DOMAIN_NAME_SERVER,
      ESP_NETIF_ROUTER_SOLICITATION_ADDRESS,
      ESP_NETIF_VENDOR_SPECIFIC_INFO,
      ESP_NETIF_REQUESTED_IP_ADDRESS,
      ESP_NETIF_IP_ADDRESS_LEASE_TIME,
      ESP_NETIF_IP_REQUEST_RETRY_TIME,
      ESP_NETIF_VENDOR_CLASS_IDENTIFIER,
      ESP_NETIF_CAPTIVEPORTAL_URI) with Convention => C;
   for esp_netif_dhcp_option_id_t use
     (ESP_NETIF_SUBNET_MASK                   => 1,
      ESP_NETIF_DOMAIN_NAME_SERVER            => 6,
      ESP_NETIF_ROUTER_SOLICITATION_ADDRESS   => 32,
      ESP_NETIF_VENDOR_SPECIFIC_INFO          => 43,
      ESP_NETIF_REQUESTED_IP_ADDRESS          => 50,
      ESP_NETIF_IP_ADDRESS_LEASE_TIME         => 51,
      ESP_NETIF_IP_REQUEST_RETRY_TIME         => 52,
      ESP_NETIF_VENDOR_CLASS_IDENTIFIER       => 60,
      ESP_NETIF_CAPTIVEPORTAL_URI             => 114);

   type esp_ip4_addr_t is record
      addr : A0B.Types.Big_Endian.Unsigned_32;
   end record with Convention => C;

   type esp_netif_ip_info_t is record
      ip      : esp_ip4_addr_t;
      netmask : esp_ip4_addr_t;
      gw      : esp_ip4_addr_t;
   end record with Convention => C;

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

   function esp_netif_get_ip_info
     (netif   : esp_netif_t_ptr;
      ip_info : out esp_netif_ip_info_t) return esp_err_t
     with Import, Convention => C, External_Name => "esp_netif_get_ip_info";

   procedure esp_netif_get_ip_info
     (netif   : esp_netif_t_ptr;
      ip_info : out esp_netif_ip_info_t);

   function esp_netif_dhcps_option
     (esp_netif : esp_netif_t_ptr;
      opt_op    : esp_netif_dhcp_option_mode_t;
      opt_id    : esp_netif_dhcp_option_id_t;
      opt_val   : System.Address;
      opt_len   : uint32_t) return esp_err_t
     with Import, Convention => C, External_Name => "esp_netif_dhcps_option";

   procedure esp_netif_dhcps_option
     (esp_netif : esp_netif_t_ptr;
      opt_op    : esp_netif_dhcp_option_mode_t;
      opt_id    : esp_netif_dhcp_option_id_t;
      opt_val   : System.Address;
      opt_len   : uint32_t);

   function esp_netif_dhcps_option_SET_CAPTIVEPORTAL_URI
     (esp_netif : esp_netif_t_ptr;
      opt_val   : ESPIDF.C_Strings.const_char_ptr) return esp_err_t;

   procedure esp_netif_dhcps_option_SET_CAPTIVEPORTAL_URI
     (esp_netif : esp_netif_t_ptr;
      opt_val   : ESPIDF.C_Strings.const_char_ptr);

private

   type esp_netif_t is limited null record with Convention => C;
   --  Full declaration of this type is not visible via "esp_netif.h"

end ESPIDF.NETIF;
