--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

with ESPIDF.Ada_ESP_Check_Error;

package body ESPIDF.NETIF is

   --------------------
   -- esp_netif_init --
   --------------------

   procedure esp_netif_init is
   begin
      Ada_ESP_Check_Error (esp_netif_init);
   end esp_netif_init;

end ESPIDF.NETIF;
