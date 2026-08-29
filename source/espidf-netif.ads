--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

package ESPIDF.NETIF is

   function esp_netif_init return esp_err_t
     with Import, Convention => C, External_Name => "esp_netif_init";

   procedure esp_netif_init;

end ESPIDF.NETIF;
