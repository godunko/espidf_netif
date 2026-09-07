--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

with ESPIDF.Ada_ESP_Check_Error;

package body ESPIDF.NETIF is

   ----------------------------
   -- esp_netif_dhcps_option --
   ----------------------------

   procedure esp_netif_dhcps_option
     (esp_netif : esp_netif_t_ptr;
      opt_op    : esp_netif_dhcp_option_mode_t;
      opt_id    : esp_netif_dhcp_option_id_t;
      opt_val   : System.Address;
      opt_len   : uint32_t) is
   begin
      Ada_ESP_Check_Error
        (esp_netif_dhcps_option
           (esp_netif, opt_op, opt_id, opt_val, opt_len));
   end esp_netif_dhcps_option;

   ---------------------------
   -- esp_netif_get_ip_info --
   ---------------------------

   procedure esp_netif_get_ip_info
     (netif   : esp_netif_t_ptr;
      ip_info : out esp_netif_ip_info_t) is
   begin
      Ada_ESP_Check_Error (esp_netif_get_ip_info (netif, ip_info));
   end esp_netif_get_ip_info;

   --------------------
   -- esp_netif_init --
   --------------------

   procedure esp_netif_init is
   begin
      Ada_ESP_Check_Error (esp_netif_init);
   end esp_netif_init;

end ESPIDF.NETIF;
