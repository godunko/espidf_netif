--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

package ESPIDF.NETIF is

   type esp_netif_t is limited private;

   type esp_netif_t_ptr is access all esp_netif_t with Convention => C;

   function esp_netif_init return esp_err_t
     with Import, Convention => C, External_Name => "esp_netif_init";

   procedure esp_netif_init;

private

   type esp_netif_t is limited null record with Convention => C;
   --  Full declaration of this type is not visible via "esp_netif.h"

end ESPIDF.NETIF;
